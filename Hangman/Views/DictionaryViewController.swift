// DictionaryViewController.swift
// Hangman
//
// Created by William Workdesk on 2023-08-21.

import UIKit

// Manages the dictionary word selection interface.
class DictionaryViewController: UIViewController {
    @IBOutlet weak var hintLabel: UILabel!           // Displays a hint for the selected word
    @IBOutlet weak var startButton: UIButton!       // Button to start the game with the selected word
 
    // MARK: - Properties
    var selectedWord: DictionaryWord?            // The word currently selected for the game

    // MARK: - View Lifecycle
                                              // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
                                          // Fetch a new word and display its hint.
        fetchAndDisplayNewWord()

                                       // Set the title for the navigation and tab bar.
        self.title = "Dictionary"
        self.tabBarItem.title = "Dictionary"
        
    }
    
    // MARK: - Game Setup
                                                   
    func fetchAndDisplayNewWord() {               // Fetches a new word from the dictionary manager and updates the hint label.
                                                 // Attempt to get a random word from the Word Manager.
        if let word = WordManager.shared.getRandomWord() {
                                               // If a word is successfully retrieved, update the selected word and hint label.
            self.selectedWord = word
            hintLabel.text = word.hint
            
        } else {
                                         // If no words are available, display  message.
            hintLabel.text = "No words available!"
            
        }
    }
    
    // MARK: - Navigation
    // Prepares for the segue to the game view controller with the selected dictionary word.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                                                                        // Check if the correct segue is being performed with the intended destination and sender.
        if segue.identifier == "segueToGameViewController",
           let gameVC = segue.destination as? GameViewController,
           let word = sender as? DictionaryWord {
                                                                   // Pass the selected dictionary word to the game view controller and set its mode to .dictionary.
            gameVC.selectedWord = word
            gameVC.mode = .dictionary
            
        }
    }
    
    

    // MARK: - Actions
    @IBAction func startButtonTapped(_ sender: UIButton) {
        
        // Perform the segue with the selected dictionary word as the sender.
        performSegue(withIdentifier: "segueToGameViewController", sender: selectedWord)
        
    }
}
            


