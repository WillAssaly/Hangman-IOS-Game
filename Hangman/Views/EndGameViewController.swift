//
//  EndGameViewController.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-23.
//

import UIKit

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var resultlabel: UILabel!
    var gameResults: String?
    var gameInfo: EndOfGameInformation?
    
    @IBAction func playAgainTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil) // dissmissing the modal (Go back)
        }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let gameInfoMessage = gameInfo?.finalMessage {
            resultlabel.text = gameInfoMessage
        } else {
            resultlabel.text = gameResults
        }
    }
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
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
