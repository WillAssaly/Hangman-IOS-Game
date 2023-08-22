//
//  ViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
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

       func updateUI() {
           DispatchQueue.main.async {  // Ensure UI updates are made on the main thread
               self.devinetteLabel.text = JeuPendu.shared.devinette.replacingOccurrences(of: "#", with: "-")
//               print("Letters to display: \(JeuPendu.shared.lettreUtilisees)") // Debugging line
               self.userUsedLetters.text = JeuPendu.shared.lettreUtilisees
               self.hangmanView.image = JeuPendu.shared.image
               self.PointsLabel.text = "Points: \(JeuPendu.shared.currentErrors) / 7"

               if let endMessage = JeuPendu.shared.verifierFinDepartie() {
                   let isWin = endMessage.contains("win: true")
                   let alertTitle = isWin ? "Congratulations!" : "End of Game"
                   let alert = UIAlertController(title: alertTitle, message: endMessage, preferredStyle: .alert)
                   let action = UIAlertAction(title: "OK", style: .default) { _ in
                       self.fetchRandomMovieAndPrintTitle()
                   }
                   alert.addAction(action)
                   self.present(alert, animated: true)
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
