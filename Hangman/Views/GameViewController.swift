//
//  ViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import UIKit


// Enum to manage the game modes available.
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
    
    // Flags and current game state properties.
    var isNewGame: Bool = true                               // Indicates if a new game should be started
    var currentAnswer: String?                              // The current answer the user is trying to guess
       var mode: GameMode = .movie                         // The default game mode is set to movie
       var letters = Array("abcdefghijklmnopqrstuvwxyz")  // Array of alphabet letters for the picker
       
    // Optional properties for selected movie or word when playing in specific mode.
       var selectedMovie: Movie?
       var selectedWord: DictionaryWord?
    
    
    // MARK: - View Lifecycle
                                                  // Called before the view is added to the view hierarchy.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    // Initializes the game based on the current game mode and selected options.
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

            isNewGame = false // Reset the flag for new game
        }
    }
   
                                                                         
    override func viewDidLoad() {super.viewDidLoad()          // Called after the controller's view is loaded into memory.
        self.tabBarController?.delegate = self               // Assign the tab bar controller delegate to self.
                                                                   
        userInputField.delegate = self                     // Setup for the user input picker view.
        userInputField.dataSource = self
        userUsedLetters.isUserInteractionEnabled = false // Disable interaction for the label that shows used letters.
                                                            
        resetLetters()                                 // Prepare the letters for the picker view.
        initializeGame()                              // Initialize game
    }
    
    

    
       
       //MARK:  - Game Start
    
                                                    // Start a new game with a selected movie.
       func startGame(with movie: Movie) {
           currentAnswer = movie.Title            // Set the current answer to the movie title
           JeuPendu.shared.jouer(avec: movie)    // Start the game with the movie object
           updateUI()                           // Update the user interface
       }
    
                                                    // Start a new game with a given word.
       func startGame(with word: String) {
           currentAnswer = word                   // Set the current answer to the word
           JeuPendu.shared.jouer(avecMot: word)  // Start the game with the word
           updateUI()                           // Update the user interface
       }
       
       // MARK: - UIPickerView DataSource & Delegate
        
                                                                    // Define the number of components in the picker view.
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
                                                                // Define the number of rows in the picker view component.
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return letters.count
       }
    
                                                            // Provide a title for each row in the picker view.
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return String(letters[row])                    // Each row title is a letter from the alphabet
       }
       
       // - Game Logic
    
    // Action for when the "Enter" button is pressed.
    @IBAction func enterButtonPressed(_ sender: UIButton) {
        let selectedRow = userInputField.selectedRow(inComponent: 0)  // Get the currently selected letter from the picker.
                let selectedLetter = letters[selectedRow]
                JeuPendu.shared.verifier(lettre: selectedLetter)    // Pass the selected letter to the game logic to verify.
                letters.remove(at: selectedRow)                    // Remove the used letter from the picker and refresh it.
                userInputField.reloadAllComponents()
                
                updateUI()
            }
    
    // Updates the interface with the current game status.
    func updateUI() {
                                                            // Ensure UI updates are on the main thread.
        DispatchQueue.main.async {
                                                          // Update puzzle label, used letters, hangman image, and points label.
            
            self.devinetteLabel.text = JeuPendu.shared.devinette.replacingOccurrences(of: "#", with: "-")
            self.userUsedLetters.text = JeuPendu.shared.lettreUtilisees
            self.hangmanView.image = JeuPendu.shared.image
            self.PointsLabel.text = "Errors: \(JeuPendu.shared.currentErrors) / 7"
            
                                                    // Determine if the game has been won or lost and perform a segue if so.
            
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

            // Resets the letters array to include all alphabets and refreshes the picker view.
            func resetLetters() {
                letters = Array("abcdefghijklmnopqrstuvwxyz")
                userInputField.reloadAllComponents()
            }
    
            // Fetches a random dictionary word and starts a new game with it.
            func fetchRandomDictionaryWordAndStartGame() {
                resetLetters()
                if let dictionaryWord = WordManager.shared.getRandomWord() {
                    startGame(with: dictionaryWord.word)
                } else {
                    print("Failed to fetch dictionary word.")
                }
            }
    
            // Fetches a random movie and starts a new game with its title.
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
            
            //MARK - Navigation
    
                                                                                   // Prepares for the segue to the end game view controller with the game results.
            override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "endGameSegue",
                   let endGameVC = segue.destination as? EndGameViewController,
                   let gameInfo = sender as? EndOfGameInformation {
                                                                               // Pass the end of game information to the destination view controller.
                    endGameVC.gameInfo = gameInfo
                }
            }
        }

// MARK: - UITabBarControllerDelegate Extension
// Extension for UITabBarControllerDelegate to manage tab bar interactions.

extension GameViewController: UITabBarControllerDelegate {         // Called when new tab selected.
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
                                                                 
        if tabBarController.selectedIndex == 0 {               // Determine the game mode based on the selected tab and reset the game if needed.
            mode = .movie
            isNewGame = true
            viewWillAppear(true)                            // Restart the game with the movie mode.
        } else if tabBarController.selectedIndex == 1 {
            isNewGame = true
            viewWillAppear(true)                         // Restart the game with the dictionary mode.
        }
        else if tabBarController.selectedIndex == 2 {
        }
    }
}

