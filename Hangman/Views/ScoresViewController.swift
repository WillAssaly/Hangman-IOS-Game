//
//  ScoresViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-09-12.
//

import UIKit
import CoreData

struct UserScore {
    let username: String
    var score: Int
}


class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resetButton: UIButton!
    
    
    
    var dictionaryScores: [UserScore] = []
    var filmsScores: [UserScore] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Fetch scores when the view loads
        fetchScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchScores()
        tableView.reloadData()
    }
    
    
    
    func calculateUserScores(for gameType: GameMode) -> [UserScore] {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        let predicate = NSPredicate(format: "username != nil AND username != '' AND gameType == %@", gameType.rawValue)
        fetchRequest.predicate = predicate
        
        do {
            let allScores = try context.fetch(fetchRequest)
            let groupedScores = Dictionary(grouping: allScores, by: { $0.username! })
            
            let summedScores: [UserScore] = groupedScores.map { (key, values) in
                let totalScore = values.reduce(0) { $0 + Int($1.score) }
                return UserScore(username: key, score: totalScore)
            }
            return summedScores.sorted(by: { $0.score > $1.score }).prefix(5).map { $0 }
            
        } catch let error {
            print("Failed to fetch scores: \(error)")
            return []
        }
    }
    
    func clearScores(for gameType: GameMode) {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        let predicate = NSPredicate(format: "gameType == %@", gameType.rawValue)
        fetchRequest.predicate = predicate
        
        do {
            let scoresToDelete = try context.fetch(fetchRequest)
            for score in scoresToDelete {
                context.delete(score)
            }
        } catch let error {
            print("Failed to fetch scores for deletion: \(error)")
        }
    }
    
    
    
    func fetchScores() {
        // 1. Calculate the aggregated scores
        dictionaryScores = calculateUserScores(for: .dictionary)
        filmsScores = calculateUserScores(for: .movie)
        
        tableView.reloadData()
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // One section for each game type
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? dictionaryScores.count : filmsScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        let userScore = indexPath.section == 0 ? dictionaryScores[indexPath.row] : filmsScores[indexPath.row]
        
        let positionLabel = cell.viewWithTag(1) as? UILabel
        let usernameLabel = cell.viewWithTag(2) as? UILabel
        let scoreLabel = cell.viewWithTag(3) as? UILabel
        
        let positions = ["1st", "2nd", "3rd", "4th", "5th"]
        positionLabel?.text = positions[indexPath.row]
        usernameLabel?.text = userScore.username
        scoreLabel?.text = "\(userScore.score)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Dictionary Game Mode" : "Films Game Mode"
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        clearAllScores()
        
        dictionaryScores = []
        filmsScores = []
        
        tableView.reloadData()
    }
    
    func clearAllScores() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Score.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error {
            print("Failed to delete all scores: \(error)")
        }
        
    }
}


