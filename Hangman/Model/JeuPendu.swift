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
    
    var image : UIImage? {
        return nbErreurs > 0 ? UIImage(named: imageNamesSequence[nbErreurs - 1]) : nil
    }

    
    func jouer (avec movie: Movie) {
        filmADeviner = movie
        titreADeviner = Array(movie.Title)
        indexTrouves = Array(repeating: false, count: titreADeviner.count)
        lettresUtilisateurs = [] 
        
        titreADeviner.enumerated().forEach {(idx, lettre) in
            if
                !("abcdefghijklmnopqrstuvwxyz".contains(lettre.lowercased())) {
                indexTrouves[idx] = true
            }
        }
        
        nbErreurs = 0
        
       
        
    }
    
    func verifier(lettre: Character) {
        lettresUtilisateurs.append(lettre)
        var trouvee = false
        
        titreADeviner.enumerated().forEach{ ( idx, lettreMystere) in
            if lettreMystere.lowercased() ==
                lettre.lowercased() {
                indexTrouves[idx] = true
                trouvee = true
            }
        }
        
        if !trouvee {
            nbErreurs += 1
        }
    }
    
    
    enum GameResult {
        case won
        case lost
        case ongoing
    }
    
    var gameStatus: GameResult {
        if !indexTrouves.contains(false) { // All letters are found
            return .won
        } else if nbErreurs == maxErreur { // Maximum number of errors reached
            return .lost
        } else {
            return .ongoing
        }
    }
    
    func verifierFinDepartie() -> EndOfGameInformation? {
        switch gameStatus {
        case .won:
            return EndOfGameInformation(win: true, title: String(titreADeviner), cntErrors: nbErreurs)
        case .lost:
            return EndOfGameInformation(win: false, title: String(titreADeviner), cntErrors: nbErreurs)
        case .ongoing:
            return nil
        }
    }
    
//    func verifierFinDepartie() -> String? {
//        if nbErreurs == maxErreur {
//            return EndOfGameInformation(win: false, title:
//                                            String(titreADeviner), cntErrors: nbErreurs).finalMessage
//
//        }
//        return nil
//        }
    
//    func verifierFinDepartie() -> String? {
//        if nbErreurs == maxErreur {
//            return EndOfGameInformation(win: false, title: String(titreADeviner), cntErrors: nbErreurs).finalMessage
//        } else if !indexTrouves.contains(false) {
//            return EndOfGameInformation(win: true, title: String(titreADeviner), cntErrors: nbErreurs).finalMessage
//        }
//        return nil
//    }
    }

struct EndOfGameInformation {
    let win: Bool
    let title: String
    let cntErrors: Int
    var finalMessage: String {
        if win {
            return """
            Congratulations!
            You guessed the title correctly!
            in \(cntErrors)/7 attempts.
            """
        } else {
            return """
            Game Over!
            The correct answer was:
            \(title)
            You made \(cntErrors) errors out of 7.
            """
        }
    }
}
    
    
    
    

