//
//  ViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import UIKit


////End game Information
//struct EndOfGameInformation {
//    let win: Bool
//    let title: String
//    let cntErrors: Int
//    var finalMessage: String {
//        if win {
//            return "Congratulations!"
//        } else {
//            return """
//Oops! wrong answer!
//The correct answer was : \(title)
//"""
//        }
//    }
//}



class GameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var devinetteLabel: UITextView!
    @IBOutlet weak var userInputField: UIPickerView!
    @IBOutlet weak var userUsedLetters: UILabel!
    @IBOutlet weak var hangmanView: UIImageView!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var PointsLabel: UILabel!
    
    
    
    var letters = Array("abcdefghijklmnopqrstuvwxyz")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userInputField.delegate = self
        userInputField.dataSource = self
        
        userUsedLetters.isUserInteractionEnabled = false
        
        self.PointsLabel.text = "Points: \(JeuPendu.shared.currentErrors) / 7"

        fetchRandomMovieAndPrintTitle()
        
        //Responding to the Restart game notification
        NotificationCenter.default.addObserver(self, selector: #selector(restartGame), name: Notification.Name("restartGameNotification"), object: nil)
        
        
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return letters.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(letters[row])
    }

    @IBAction func enterButtonPressed(_ sender: UIButton) {
           let selectedRow = userInputField.selectedRow(inComponent: 0)
           let selectedLetter = letters[selectedRow]

           JeuPendu.shared.verifier(lettre: selectedLetter)
           letters.remove(at: selectedRow)
           userInputField.reloadAllComponents()

           updateUI()
       }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "endGameSegue",
//           let endGameVC = segue.destination as? EndGameViewController {
//            endGameVC.gameResults = sender as? String
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endGameSegue",
           let endGameVC = segue.destination as? EndGameViewController,
           let gameInfo = sender as? EndOfGameInformation {
            
            endGameVC.gameInfo = gameInfo
        
        }
    }
    
    
    
    //Restart game
    @objc func restartGame() {
        fetchRandomMovieAndPrintTitle()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
 

//       func updateUI() {
//           DispatchQueue.main.async {  // Ensure UI updates are made on the main thread
//               self.devinetteLabel.text = JeuPendu.shared.devinette.replacingOccurrences(of: "#", with: "-")
////               print("Letters to display: \(JeuPendu.shared.lettreUtilisees)") // Debugging line
//               self.userUsedLetters.text = JeuPendu.shared.lettreUtilisees
//               self.hangmanView.image = JeuPendu.shared.image
//               self.PointsLabel.text = "Points: \(JeuPendu.shared.currentErrors) / 7"
//
//               if let endMessage = JeuPendu.shared.verifierFinDepartie() {
//                   let isWin = endMessage.contains("win: true")
//                   let alertTitle = isWin ? "Congratulations!" : "End of Game"
//
//                   if let endMessage = JeuPendu.shared.verifierFinDepartie() {
//                       self.performSegue(withIdentifier: "endGameSegue", sender: endMessage)
//                   }
////                   let alert = UIAlertController(title: alertTitle, message: endMessage, preferredStyle: .alert)
////                   let action = UIAlertAction(title: "OK", style: .default) { _ in
////                       self.fetchRandomMovieAndPrintTitle()
////                   }
////                   alert.addAction(action)
////                   self.present(alert, animated: true)
//               }
//           }
//       }
    
//    func updateUI() {
//        DispatchQueue.main.async {  // Ensure UI updates are made on the main thread
//            self.devinetteLabel.text = JeuPendu.shared.devinette.replacingOccurrences(of: "#", with: "-")
//            self.userUsedLetters.text = JeuPendu.shared.lettreUtilisees
//            self.hangmanView.image = JeuPendu.shared.image
//            self.PointsLabel.text = "Errors: \(JeuPendu.shared.currentErrors) / 7"
//
//
//
//
////            if let endMessage = JeuPendu.shared.verifierFinDepartie() {
////                self.fetchRandomMovieAndPrintTitle() // reset the game
////                self.performSegue(withIdentifier: "endGameSegue", sender: endMessage)
////            }
//
//            if let endMessage = JeuPendu.shared.verifierFinDepartie() {
//                self.fetchRandomMovieAndPrintTitle() // reset the game
//
//                // Determine the win status, title, and error count.
//                let gameWon = !endMessage.contains("win: false")  // This is a rudimentary check. Better would be to have a dedicated function or property in JeuPendu that gives this status.
//                let movieTitle = JeuPendu.shared.filmADeviner?.Title ?? "Unknown"
//                let errorCount = JeuPendu.shared.currentErrors
//
//                // Now create the gameInfo struct with these values
//                let gameInfo = EndOfGameInformation(win: gameWon, title: movieTitle, cntErrors: errorCount)
//
//                self.performSegue(withIdentifier: "endGameSegue", sender: gameInfo)
//            }
//
//
//        }
//    }
    
    
    func updateUI() {
        DispatchQueue.main.async {
            self.devinetteLabel.text = JeuPendu.shared.devinette.replacingOccurrences(of: "#", with: "-")
            self.userUsedLetters.text = JeuPendu.shared.lettreUtilisees
            self.hangmanView.image = JeuPendu.shared.image
            self.PointsLabel.text = "Errors: \(JeuPendu.shared.currentErrors) / 7"
            
            switch JeuPendu.shared.gameStatus {
            case .won:
                let gameInfo = EndOfGameInformation(win: true, title: JeuPendu.shared.filmADeviner?.Title ?? "Unknown", cntErrors: JeuPendu.shared.currentErrors)
                self.performSegue(withIdentifier: "endGameSegue", sender: gameInfo)
                self.fetchRandomMovieAndPrintTitle() // reset the game
            case .lost:
                let gameInfo = EndOfGameInformation(win: false, title: JeuPendu.shared.filmADeviner?.Title ?? "Unknown", cntErrors: JeuPendu.shared.currentErrors)
                self.performSegue(withIdentifier: "endGameSegue", sender: gameInfo)
                self.fetchRandomMovieAndPrintTitle() // reset the game
            case .ongoing:
                break
            }
        }
    }

    
    func resetLetters() {
        letters = Array("abcdefghijklmnopqrstuvwxyz")
        userInputField.reloadAllComponents()
    }

       func fetchRandomMovieAndPrintTitle() {
           resetLetters()
           let randomFilmID = ListeDeFilmsData.listeFilms.randomElement()!

           MovieDownloader.shared.fetchMovieDetails(by: randomFilmID) { movie in
               if let movie = movie {
                   JeuPendu.shared.jouer(avec: movie)
                   self.updateUI()  // This will now dispatch the updates on the main thread
               } else {
                   print("Failed to fetch movie details.")
               }
           }
       }

   }


