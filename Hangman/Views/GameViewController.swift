//
//  ViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import UIKit



enum GameMode: String {
    case movie = "movie"
    case dictionary = "dictionary"
}

class GameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var devinetteLabel: UITextView!
    @IBOutlet weak var userInputField: UIPickerView!
    @IBOutlet weak var userUsedLetters: UILabel!
    @IBOutlet weak var hangmanView: UIImageView!
    @IBOutlet weak var EnterButton: UIButton!
    @IBOutlet weak var PointsLabel: UILabel!
    
    var isNewGame: Bool = true // flag
    
    var currentAnswer: String?
       var mode: GameMode = .movie // default to movie mode
       var letters = Array("abcdefghijklmnopqrstuvwxyz")
       
       var selectedMovie: Movie?
       var selectedWord: DictionaryWord?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // You can leave this empty or move some view setup logic here if needed
    }

    func initializeGame() {
        if isNewGame {
            // Using the existing word or movie, or fetching a new one
            if let movie = selectedMovie {
                startGame(with: movie)
            } else if let word = selectedWord {
                startGame(with: word.word)
            } else {
                switch mode {
                case .movie:
                    fetchRandomMovieAndPrintTitle()
                case .dictionary:
                    fetchRandomDictionaryWordAndStartGame()
                }
            }

            isNewGame = false // Reset the flag
        }
    }
           
    override func viewDidLoad() {         super.viewDidLoad()
        
        self.tabBarController?.delegate = self

        // Set the UIPickerView's delegate and data source
        userInputField.delegate = self
        userInputField.dataSource = self

        // Disable interaction for the label
        userUsedLetters.isUserInteractionEnabled = false

        // Reset the letters for the picker
        resetLetters()

        // Initialize game
        initializeGame()
    }
    
    

    
       
       // MARK: - Game Start
       
       func startGame(with movie: Movie) {
           currentAnswer = movie.Title
           JeuPendu.shared.jouer(avec: movie)
           updateUI()
       }

       func startGame(with word: String) {
           currentAnswer = word
           JeuPendu.shared.jouer(avecMot: word)
           updateUI()
       }
       
       // MARK: - UIPickerView DataSource & Delegate
           
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return letters.count
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return String(letters[row])
       }
       
       // MARK: - Game Logic
    
    @IBAction func enterButtonPressed(_ sender: UIButton) {
        let selectedRow = userInputField.selectedRow(inComponent: 0)
                let selectedLetter = letters[selectedRow]
                
                JeuPendu.shared.verifier(lettre: selectedLetter)
                letters.remove(at: selectedRow)
                userInputField.reloadAllComponents()
                
                updateUI()
            }
            
    func updateUI() {
        DispatchQueue.main.async {
            self.devinetteLabel.text = JeuPendu.shared.devinette.replacingOccurrences(of: "#", with: "-")
            self.userUsedLetters.text = JeuPendu.shared.lettreUtilisees
            self.hangmanView.image = JeuPendu.shared.image
            self.PointsLabel.text = "Errors: \(JeuPendu.shared.currentErrors) / 7"
            
            let finalScoreValue = JeuPendu.shared.score

            switch JeuPendu.shared.gameStatus {
            case .won:
                let gameInfo = EndOfGameInformation(win: true, title: self.currentAnswer ?? "Unknown", cntErrors: JeuPendu.shared.currentErrors, gameMode: self.mode, finalScore: finalScoreValue)
                self.performSegue(withIdentifier: "endGameSegue", sender: gameInfo)
            case .lost:
                let gameInfo = EndOfGameInformation(win: false, title: self.currentAnswer ?? "Unknown", cntErrors: JeuPendu.shared.currentErrors, gameMode: self.mode, finalScore: finalScoreValue)
                self.performSegue(withIdentifier: "endGameSegue", sender: gameInfo)
            case .ongoing:
                break
            }
        }
    }

            
            func resetLetters() {
                letters = Array("abcdefghijklmnopqrstuvwxyz")
                userInputField.reloadAllComponents()
            }
            
            func fetchRandomDictionaryWordAndStartGame() {
                resetLetters()
                if let dictionaryWord = WordManager.shared.getRandomWord() {
                    startGame(with: dictionaryWord.word)
                } else {
                    print("Failed to fetch dictionary word.")
                }
            }
            
            func fetchRandomMovieAndPrintTitle() {
                resetLetters()
                guard let randomFilmID = ListeDeFilmsData.listeFilms.randomElement() else { return }
                MovieDownloader.shared.fetchMovieDetails(by: String(randomFilmID)) { movie in
                    if let movie = movie {
                        self.startGame(with: movie)
                    } else {
                        print("Failed to fetch movie details.")
                    }
                }
            }
            
            // MARK: - Navigation
            
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "endGameSegue",
                   let endGameVC = segue.destination as? EndGameViewController,
                   let gameInfo = sender as? EndOfGameInformation {
                    endGameVC.gameInfo = gameInfo
                }
            }
        }




extension GameViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Reset the game based on the selected tab.
        if tabBarController.selectedIndex == 0 { // Assuming 0 is the index for the movie mode.
            mode = .movie
            isNewGame = true
            viewWillAppear(true) // Or you can call another function that initializes the game.
        } else if tabBarController.selectedIndex == 1 { // Assuming 1 is the index for the dictionary mode.
            mode = .dictionary
            isNewGame = true
            viewWillAppear(true) // Or call your game initialization function.
        }
        // Assuming 2 is the index for stats. Do nothing for this tab.
        else if tabBarController.selectedIndex == 2 {
            // No game initialization.
        }
    }
}

