//
//  ViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var devinetteLabel: UITextView!
    @IBOutlet weak var userInputField: UIPickerView!
    @IBOutlet weak var userUsedLetters: UITextField!
    @IBOutlet weak var hangmanView: UIImageView!
    @IBOutlet weak var EnterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        fetchRandomMovieAndPrintTitle()
    }
    
    func fetchRandomMovieAndPrintTitle() {
        
        let randomFilmID = ListeDeFilmsData.listeFilms.randomElement()!
        
        MovieDownloader.shared.fetchMovieDetails(by: randomFilmID) { movie in
            if let movie = movie {
                print((movie.Title))
            } else {
                print("Failed to fetch movie details.")
            }
        }
    }
}

