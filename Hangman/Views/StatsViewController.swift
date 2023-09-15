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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
