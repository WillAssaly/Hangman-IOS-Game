//
//  StatsViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-21.
//

import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var scoresButton: UIButton!
    @IBOutlet weak var preferencesButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Stats"
        self.tabBarItem.title = "Stats"
    }
    

}
