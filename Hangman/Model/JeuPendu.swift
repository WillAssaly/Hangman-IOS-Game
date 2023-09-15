//
//  JeuPendu.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import Foundation
import UIKit



class JeuPendu {
    static let shared: JeuPendu = JeuPendu()
    
    private init() {}
    
    private let maxErreur: Int = 7
    private var nbErreurs: Int = 0
    private var titreADeviner: [Character] = []
    private var indexTrouves: [Bool] = []
    private var lettresUtilisateurs: [Character] = []
    var filmADeviner: Movie?
    var score: Int = 0
    
    
    var devinette: String {
        let arr = indexTrouves.indices.map {indexTrouves[$0]
            ? titreADeviner[$0] : "#"}
        return String(arr)
    }
    var lettreUtilisees: String {
        return Array(lettresUtilisateurs).map
        {String($0)}.joined(separator: ", ")
    }
    var erreurs: String {
        return "\(nbErreurs) / \(maxErreur)"
    }
    
    var currentErrors: Int { //new
        return nbErreurs
    }
    
    var isGameInProgress: Bool {
        return !(devinette == String(repeating: "#", count: devinette.count))
    }
    
    var image : UIImage? {
        return nbErreurs > 0 ? UIImage(named: imageNamesSequence[nbErreurs - 1]) : nil
    }

    
    func jouer(avec movie: Movie) {
           filmADeviner = movie
           resetGame(withTitle: movie.Title)
       }
       
       func jouer(avecMot word: String) {
           filmADeviner = nil  // Reset the movie property
           resetGame(withTitle: word)
       }
    private func resetGame(withTitle title: String) {
            titreADeviner = Array(title)
            indexTrouves = Array(repeating: false, count: titreADeviner.count)
            lettresUtilisateurs = []
            
            titreADeviner.enumerated().forEach {(idx, lettre) in
                if !("abcdefghijklmnopqrstuvwxyz".contains(lettre.lowercased())) {
                    indexTrouves[idx] = true
                }
            }
        
            nbErreurs = 0
            score = 0
        }

    
    func verifier(lettre: Character) {
            lettresUtilisateurs.append(lettre)
            var trouvee = false
            
            titreADeviner.enumerated().forEach{ ( idx, lettreMystere) in
                if lettreMystere.lowercased() == lettre.lowercased() {
                    indexTrouves[idx] = true
                    trouvee = true
                    score += 10
                }
            }
            
            if !trouvee {
                nbErreurs += 1
                score -= 5
            }
        }
    
    
    enum GameResult {
        case won
        case lost
        case ongoing
    }
    
    var gameStatus: GameResult {
        if !indexTrouves.contains(false) {// All letters are found
            score += 50
            return .won
        } else if nbErreurs == maxErreur { // Maximum number of errors reached
            return .lost
        } else {
            return .ongoing
        }
    }
    
    func verifierFinDepartie() -> EndOfGameInformation? {
        let currentGameMode: GameMode = filmADeviner != nil ? .movie : .dictionary
        
        switch gameStatus {
        case .won:
            return EndOfGameInformation(win: true, title: String(titreADeviner), cntErrors: nbErreurs, gameMode: currentGameMode, finalScore: score)
        case .lost:
            return EndOfGameInformation(win: false, title: String(titreADeviner), cntErrors: nbErreurs, gameMode: currentGameMode, finalScore: score)
        case .ongoing:
            return nil
        }
    }
    
    

    }



struct EndOfGameInformation {
    var win: Bool
    var title: String? // movie title or dictionary word
    var cntErrors: Int
    var gameMode: GameMode
    var finalScore: Int

    var finalMessage: String {
        if win {
            return "Congratulations! You won with \(cntErrors) errors. The answer was \(title ?? "Unknown")."
        } else {
            switch gameMode {
            case .movie:
                return "Sorry, you lost with \(cntErrors) errors. The correct movie was \(title ?? "Unknown")."
            case .dictionary:
                return "Sorry, you lost with \(cntErrors) errors. The correct word was \(title ?? "Unknown")."
            }
        }
    }
}







