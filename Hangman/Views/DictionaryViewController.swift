// DictionaryViewController.swift
// Hangman
//
// Created by William Workdesk on 2023-08-21.

import UIKit

class DictionaryViewController: UIViewController {
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var selectedWord: DictionaryWord?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplayNewWord()

        
        self.title = "Dictionary"
        self.tabBarItem.title = "Dictionary"
        
    }
    
    func fetchAndDisplayNewWord() {
        if let word = WordManager.shared.getRandomWord() {
            self.selectedWord = word
            hintLabel.text = word.hint
        } else {
            hintLabel.text = "No words available!"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToGameViewController",
           let gameVC = segue.destination as? GameViewController,
           let word = sender as? DictionaryWord {
            gameVC.selectedWord = word
            gameVC.mode = .dictionary
        }
    }
    
    

    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToGameViewController", sender: selectedWord)
        
    }
}
            
//            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//                if segue.identifier == "segueToGameViewController",
//                   let gameVC = segue.destination as? GameViewController {
//                    gameVC.mode = .dictionary
//                    gameVC.delegate = self
//                }
//            }
//            
//            func gameDidLoadNewWord(_ word: String) {
//                if let dictionaryWord = WordManager.shared.getWordsFromDefaults()?.first(where: { $0.word == word }) {
//                    hintLabel.text = dictionaryWord.hint
//                }
//            }
//        }







//        if let word = WordManager.shared.getRandomWord() {
//            JeuPendu.shared.jouer(avecMot: word.word)
//        } else {
//            print("Failed to fetch dictionary word.")
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToGameViewController",
//           let gameVC = segue.destination as? GameViewController {
//            gameVC.mode = .dictionary
//            gameVC.delegate = self
//        }
//    }
//
//
//
//    func gameDidLoadNewWord(_ word: String) {
//        if let dictionaryWord = WordManager.shared.getWordsFromDefaults()?.first(where: { $0.word == word }) {
//            hintLabel.text = dictionaryWord.hint
//        }
//    }
//
//}

