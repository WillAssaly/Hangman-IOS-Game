//
//  JeuPendu.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import Foundation
import UIKit


// Manages the state and logic of the  game.
class JeuPendu {
    static let shared: JeuPendu = JeuPendu()     // Singleton instance for the game logic.
    
    private init() {}                          // Private initializer to prevent outside instantiation.
    
    // Constants and variables for managing game state.
    private let maxErreur: Int = 7                        // The maximum number of errors allowed.
    private var nbErreurs: Int = 0                       // The current number of errors made by the player.
    private var titreADeviner: [Character] = []         // The title to be guessed, as an array of characters.
    private var indexTrouves: [Bool] = []              // Array indicating which letters have been correctly guessed.
    private var lettresUtilisateurs: [Character] = [] // Letters guessed by the user.
    var filmADeviner: Movie?                         // The movie object if the game is in movie mode.
    var score: Int = 0                              // The current score of the player.
    
    // Computed properties to provide game status information.
    var devinette: String {
        let arr = indexTrouves.indices.map {indexTrouves[$0]         // Represents the current state of the guessed title, with unguessed letters as "#".
            ? titreADeviner[$0] : "#"}
        return String(arr)
    }
    var lettreUtilisees: String {
                                                // A string representation of all the letters guessed by the user so far.
        return Array(lettresUtilisateurs).map
        {String($0)}.joined(separator: ", ")
    }
    var erreurs: String {
                                            // A string showing the current number of errors out of the maximum allowed.
        return "\(nbErreurs) / \(maxErreur)"
    }
    
    var currentErrors: Int {
                                       // The current number of errors as an integer.
        return nbErreurs
    }
    
    var isGameInProgress: Bool {
                                                                // Indicates if the game is in progress (false if all letters are guessed).
        return !(devinette == String(repeating: "#", count: devinette.count))
    }
    
    var image : UIImage? {
                                                          // The image to display corresponding to the current number of errors.
        return nbErreurs > 0 ? UIImage(named: imageNamesSequence[nbErreurs - 1]) : nil
    }

    // Game initialization functions.
    func jouer(avec movie: Movie) {
                                                    // Start the game with a movie, setting up the initial game state.
           filmADeviner = movie
           resetGame(withTitle: movie.Title)
       }
       
       func jouer(avecMot word: String) {
                                               // Start the game with a word, resetting any movie-specific state.
           filmADeviner = nil                 // Reset the movie property
           resetGame(withTitle: word)
       }
    private func resetGame(withTitle title: String) {
                                          // Prepare the game with the given title, resetting game state.
            titreADeviner = Array(title)
            indexTrouves = Array(repeating: false, count: titreADeviner.count)
            lettresUtilisateurs = []
                                    // Automatically reveal any non-letter characters.
            titreADeviner.enumerated().forEach {(idx, lettre) in
                if !("abcdefghijklmnopqrstuvwxyz".contains(lettre.lowercased())) {
                    indexTrouves[idx] = true
                }
            }
        
            nbErreurs = 0
            score = 0
        }

    // Function to process a user's letter guess.
    func verifier(lettre: Character) {
                                                           // Add the guessed letter to the list of user guesses.
            lettresUtilisateurs.append(lettre)
            var trouvee = false
                                                        // Check each letter in the title to be guessed.
            titreADeviner.enumerated().forEach{ ( idx, lettreMystere) in
                if lettreMystere.lowercased() == lettre.lowercased() {
                    indexTrouves[idx] = true
                    trouvee = true
                    score += 10                    // Increment score for correct guess.
                }
            }
                                                // Increment the error count and decrement score if the guess is wrong.
            if !trouvee {
                nbErreurs += 1
                score -= 5
            }
        }
    
    // Enumeration to represent the possible results of the game.
    enum GameResult {
        case won
        case lost
        case ongoing
    }
    // Computed property to determine the current game status.
    var gameStatus: GameResult {
        if !indexTrouves.contains(false) {            // All letters have been found, the game is won.
            score += 50
            return .won
        } else if nbErreurs == maxErreur {         // The maximum number of errors has been reached, the game is lost.
            return .lost
        } else {
                                                // Neither winning nor losing condition has been met, the game continues.
            return .ongoing
        }
    }
    
    // Checks if the game is over and returns an EndOfGameInformation struct if it is.
    func verifierFinDepartie() -> EndOfGameInformation? {
        
                                                            // Determine the current game mode based on whether a movie is being guessed.
        
        let currentGameMode: GameMode = filmADeviner != nil ? .movie : .dictionary
        
                                                         // Return game information based on the current status of the game.
        switch gameStatus {
        case .won:
            // If won, return a struct indicating a win, the title, error count, game mode, and final score.
            return EndOfGameInformation(win: true, title: String(titreADeviner), cntErrors: nbErreurs, gameMode: currentGameMode, finalScore: score)
        case .lost:
            // If lost, return a struct indicating a loss, the title, error count, game mode, and final score.
            return EndOfGameInformation(win: false, title: String(titreADeviner), cntErrors: nbErreurs, gameMode: currentGameMode, finalScore: score)
        case .ongoing:
            // If the game is still ongoing, return nil as it's not over yet.
            return nil
        }
    }
    
    

    }


// Holds end-of-game data including win status, title, error count, game mode, and final score.
struct EndOfGameInformation {
    var win: Bool
    var title: String? // movie title or dictionary word
    var cntErrors: Int
    var gameMode: GameMode
    var finalScore: Int

    // Computed property to generate a final message based on game outcome.
    var finalMessage: String {
        if win {
            // Message for a win includes the number of errors and the correct answer.
            return "Congratulations! You won with \(cntErrors) errors. The answer was \(title ?? "Unknown")."
        } else {
            // Message for a loss includes the number of errors and the correct answer, with differentiation based on the game mode.
            switch gameMode {
            case .movie:
                return "Sorry, you lost with \(cntErrors) errors. The correct movie was \(title ?? "Unknown")."
            case .dictionary:
                return "Sorry, you lost with \(cntErrors) errors. The correct word was \(title ?? "Unknown")."
            }
        }
    }
}







