//
//  ScoreTableViewCell.swift
//  Hangman
//
//  Created by William Workdesk on 2023-09-14.
//

import Foundation
import UIKit

class ScoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(position: Int, username: String, score: Int16) {
        let positions = ["1st", "2nd", "3rd", "4th", "5th"]
        positionLabel.text = positions[position]
        usernameLabel.text = username
        scoreLabel.text = "\(score)"
    }
}
