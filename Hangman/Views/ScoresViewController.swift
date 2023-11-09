//
//  ScoresViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-09-12.
//

import UIKit
import CoreData

struct UserScore {       // Structure to hold a user's score.
    let username: String
    var score: Int
}

// ViewController to manage and display scores from the Hangman game.
class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!    // Table view to display scores.
    @IBOutlet weak var resetButton: UIButton!    // Button to reset scores.
    
    
    // MARK: - Properties
    var dictionaryScores: [UserScore] = []   // Array to hold dictionary game mode scores.
    var filmsScores: [UserScore] = []       // Array to hold films game mode scores.
    
    // Access the Core Data context to fetch and save data.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - View Lifecycle
    // Called after the view controller’s view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Fetch scores when the view loads
        fetchScores()
    }
    
    // Called just before the view controller’s view is added to the view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchScores()                // Fetch scores every time the view will appear.
        tableView.reloadData()      // Reload the table view with new data.
    }
    
    
    // MARK: - Score Handling
    // Calculates the top user scores for a given game type.
    func calculateUserScores(for gameType: GameMode) -> [UserScore] {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        
        // Filter the request for scores of a specific game type.
        let predicate = NSPredicate(format: "username != nil AND username != '' AND gameType == %@", gameType.rawValue)
        fetchRequest.predicate = predicate
        
        do {
                                                                          // Fetch scores from Core Data.
            let allScores = try context.fetch(fetchRequest)
                                                                        // Group scores by username.
            let groupedScores = Dictionary(grouping: allScores, by: { $0.username! })
            
                                                                     // Sum up scores for each user and create UserScore instances.
            let summedScores: [UserScore] = groupedScores.map { (key, values) in
                let totalScore = values.reduce(0) { $0 + Int($1.score) }
                return UserScore(username: key, score: totalScore)
            }
                                                                 // Return the top 5 scores, sorted in descending order.
            return summedScores.sorted(by: { $0.score > $1.score }).prefix(5).map { $0 }
            
        } catch let error {
            print("Failed to fetch scores: \(error)")
            return []
        }
    }
    
    // Clears scores from Core Data for a specific game type.
    func clearScores(for gameType: GameMode) {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
                                                                                // Filter the request for scores of a specific game type.
        let predicate = NSPredicate(format: "gameType == %@", gameType.rawValue)
        fetchRequest.predicate = predicate
        
        do {
                                                                         // Fetch scores to be deleted.
            let scoresToDelete = try context.fetch(fetchRequest)
            for score in scoresToDelete {
                context.delete(score)                                 // Delete each score.
            }
        } catch let error {
            print("Failed to fetch scores for deletion: \(error)")
        }
    }
    
    
    // Fetches scores for both game types and reloads the table view.
    func fetchScores() {
                                                            // Calculate the aggregated scores for each game type.
        dictionaryScores = calculateUserScores(for: .dictionary)
        filmsScores = calculateUserScores(for: .movie)
                                                        // Refresh the table view to show the latest scores.
        tableView.reloadData()
    }
    
    
    
    // MARK: - UITableViewDataSource
    // Returns the number of sections in the table view.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2                                // One section for each game type
    }
    
    // Returns the number of rows in a given section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? dictionaryScores.count : filmsScores.count
    }
                                         // Configures and returns the cells for the table view.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
                                    // Determine which set of scores to use based on the section.
        
        let userScore = indexPath.section == 0 ? dictionaryScores[indexPath.row] : filmsScores[indexPath.row]
        
                                // Retrieve cell subviews using tags and update them with the score data.
        
        let positionLabel = cell.viewWithTag(1) as? UILabel
        let usernameLabel = cell.viewWithTag(2) as? UILabel
        let scoreLabel = cell.viewWithTag(3) as? UILabel
        
                         // Define position strings for the first five indices (0-4).
        
        let positions = ["1st", "2nd", "3rd", "4th", "5th"]
        positionLabel?.text = positions[indexPath.row]      // Assign rank based on row index.
        usernameLabel?.text = userScore.username           // Display the username from the score data.
        scoreLabel?.text = "\(userScore.score)"           // Display the score from the score data.
        
        
        return cell                                    // Return the configured cell.
    }
    // Provides a title for each section header in the table view.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Dictionary Game Mode" : "Films Game Mode"  // Return a different title depending on the section.
    }
    
    // MARK: - Reset Scores
    // Action for when the reset button is pressed.
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        clearAllScores()                                        // Clear all scores from Core Data.
                                                               // Reset the local arrays holding the scores.
        dictionaryScores = []
        filmsScores = []
                                                            // Reload the table view to reflect the score reset.
        tableView.reloadData()
    }
    
    // Clears all scores for both game types from Core Data.
    func clearAllScores() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Score.fetchRequest()
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
                                                   // Perform the delete action.
            try context.execute(deleteRequest)
            try context.save()                   // Save the context after deletion.
        } catch let error {
            print("Failed to delete all scores: \(error)")
                                              // Handle the error, perhaps by showing an alert to the user.
        }
        
    }
}


