//
//  ViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRandomMovieAndPrintTitle()
    }

    func fetchRandomMovieAndPrintTitle() {
        
        let randomFilmID = ListeDeFilmsData.listeFilms.randomElement()!
        
        MovieDownloader.shared.fetchMovieDetails(by: randomFilmID) { movie in
            if let movie = movie {
                print("Random Movie Title: \(movie.Title)")
            } else {
                print("Failed to fetch movie details.")
            }
        }
    }
}

