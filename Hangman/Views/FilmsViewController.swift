//
//  FilmsViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-21.
//

import UIKit

//protocol FilmsViewControllerDelegate: AnyObject {
//    func didChooseMovie(with id: String)
//}

class FilmsViewController: UIViewController {
    @IBOutlet weak var StartGameButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
//    weak var delegate: FilmsViewControllerDelegate?
    
    var selectedMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplayHint()
        
        self.title = "Films"
        self.tabBarItem.title = "Films"
        
    }
    
    func fetchAndDisplayHint() {
        guard let randomFilmID = ListeDeFilmsData.listeFilms.randomElement() else { return }
        
        MovieDownloader.shared.fetchMovieDetails(by: randomFilmID) { [weak self] movie in
            guard let strongSelf = self, let fetchedMovie = movie else { return }
            DispatchQueue.main.async {
                strongSelf.selectedMovie = fetchedMovie
                let hint = "\(fetchedMovie.Year) - \(fetchedMovie.Director)"
                strongSelf.hintLabel.text = hint
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yourSegueIdentifier",
           let gameVC = segue.destination as? GameViewController,
           let movie = sender as? Movie {
            gameVC.selectedMovie = movie
            gameVC.mode = .movie
        }
    }

    
    
    @IBAction func startGameTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "yourSegueIdentifier", sender: selectedMovie)
    }
}
        
        
     
//        if let movie = selectedMovie {
//            delegate?.didChooseMovie(with: movie.imdbID)
//            self.performSegue(withIdentifier: "yourSegueIdentifier", sender: self)
//        } else {
//
//        }
//    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */




