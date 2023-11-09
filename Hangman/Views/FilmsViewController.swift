//
//  FilmsViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-21.
//

import UIKit

// The view controller that handles film selection for starting a new Hangman game.
class FilmsViewController: UIViewController {
    @IBOutlet weak var StartGameButton: UIButton!// Button to start the game with the selected film
    @IBOutlet weak var hintLabel: UILabel!      // Label to display hints about the film
    
    // MARK: - Properties
    var selectedMovie: Movie?                // The currently selected movie for the game
    
    // MARK: - View Lifecycle
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
                                     // Fetch a film hint to display and setup UI elements.
        fetchAndDisplayHint()
                                   // Set the title for the navigation bar and the tab bar item.
        self.title = "Films"
        self.tabBarItem.title = "Films"
        
    }
    
    // MARK: - Game Setup
    // Fetches a random film and updates the hint label with its details.
    func fetchAndDisplayHint() {
                                                                                              
        guard let randomFilmID = ListeDeFilmsData.listeFilms.randomElement() else { return } // Get a random film ID from the list.
        MovieDownloader.shared.fetchMovieDetails(by: randomFilmID) { [weak self] movie in   // Fetch film  details + update the UI accordingly.
            guard let strongSelf = self, let fetchedMovie = movie else { return } // Ensure selfs still around +  movie was fetched successfully.
            DispatchQueue.main.async {
                                                                                       // Set the selected movie and display a hint.
                strongSelf.selectedMovie = fetchedMovie
                let hint = "\(fetchedMovie.Year) - \(fetchedMovie.Director)"
                strongSelf.hintLabel.text = hint
            }
        }
    }
    
    // MARK: - Navigation
                                                                           // Prepares for the segue to the game view controller with the selected movie.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                                                                        // Check if we're performing the correct segue with the correct destination and sender.
        if segue.identifier == "yourSegueIdentifier",
           let gameVC = segue.destination as? GameViewController,
           let movie = sender as? Movie {
                                                                    // Pass the selected movie and set the mode to .movie on the game view controller.
            gameVC.selectedMovie = movie
            gameVC.mode = .movie
        }
    }

    

    // MARK: - Actions
                                                           // Action for when the "Start Game" button is tapped.
    @IBAction func startGameTapped(_ sender: UIButton) {
                                                         // Perform the segue with the selected movie as the sender.
        performSegue(withIdentifier: "yourSegueIdentifier", sender: selectedMovie)
    }
}
        
        
     



