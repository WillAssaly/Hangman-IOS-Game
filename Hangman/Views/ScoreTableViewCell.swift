//
//  ScoreTableViewCell.swift
//  Hangman
//
//  Created by William Workdesk on 2023-09-14.
//

import Foundation
import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var positionLabel: UILabel!  // Label to display the ranking position.
    @IBOutlet weak var usernameLabel: UILabel! // Label to display the username.
    @IBOutlet weak var scoreLabel: UILabel!   // Label to display the score.
    
    // Called when the cell has been loaded from the storyboard.
    override func awakeFromNib() {
        super.awakeFromNib()
                                         // Initialization code
    }
    // Configures the cell with the ranking position, username, and score.
    func configure(position: Int, username: String, score: Int16) {
                                                             // Positions array to convert the position index to a medal position.
        let positions = ["1st", "2nd", "3rd", "4th", "5th"]
        positionLabel.text = positions[position]           // Set the ranking position.
        usernameLabel.text = username                     // Set the username.
        scoreLabel.text = "\(score)"                     // Convert the score to a String and set it.
    }
}
