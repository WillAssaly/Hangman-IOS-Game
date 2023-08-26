//
//  FilmsViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-21.
//

import UIKit

protocol FilmsViewControllerDelegate: AnyObject {
    func didChooseMovie(with id: Int)
}

class FilmsViewController: UIViewController {
    @IBOutlet weak var StartGameButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    weak var delegate: FilmsViewControllerDelegate?
    
    
    var selectedMovie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplayHint()
        
        self.title = "Films"
        self.tabBarItem.title = "Films"

        // Do any additional setup after loading the view.
    }
    
    func fetchAndDisplayHint() {
        // Use your MovieDownloader to fetch movie details
        // For demo, I'm using a hardcoded movie id. Replace with your own logic.
        MovieDownloader.shared.fetchMovieDetails(by: "tt1234567") { [weak self] movie in
            guard let strongSelf = self, let fetchedMovie = movie else { return }
            DispatchQueue.main.async {
                strongSelf.selectedMovie = fetchedMovie
                let hint = "\(fetchedMovie.Year) - \(fetchedMovie.Director)"
                strongSelf.hintLabel.text = hint
            }
        }
    }

    @IBAction func startGameTapped(_ sender: UIButton) {
        if let movie = selectedMovie {
            JeuPendu.shared.jouer(avec: movie)
            
            // Navigate to the GameViewController
            self.performSegue(withIdentifier: "yourSegueIdentifier", sender: self)
        } else {
            // Handle any error if a movie wasn't selected
            // Perhaps show an alert to the user
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


