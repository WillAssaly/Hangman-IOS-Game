import UIKit
import CoreData  // Ensure you import CoreData

class EndGameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var resultlabel: UILabel!
    @IBOutlet weak var scorelabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var gameResults: String?
    var gameInfo: EndOfGameInformation?
    
    // Make sure your AppDelegate has a property called 'persistentContainer'
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBAction func playAgainTapped(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {
            self.dismiss(animated: true, completion: nil) // Use this if not inside a navigation controller
            return
        }
        
        if let filmsViewController = navigationController.viewControllers.first(where: { $0 is FilmsViewController }) {
            (filmsViewController as? FilmsViewController)?.fetchAndDisplayHint()
            navigationController.popToViewController(filmsViewController, animated: true)
        } else if let dictionaryViewController = navigationController.viewControllers.first(where: { $0 is DictionaryViewController }) {
            (dictionaryViewController as? DictionaryViewController)?.fetchAndDisplayNewWord()
            navigationController.popToViewController(dictionaryViewController, animated: true)
        }
    }

    func saveGameData(username: String) {
        // Ensure you have an entity named 'DataModel' in your Core Data model
        let gameData = NSEntityDescription.insertNewObject(forEntityName: "Score", into: context) as! Score // Make sure your entity's name matches here if it's not "DataModel"
        
        gameData.username = username
        gameData.score = Int16(JeuPendu.shared.score)
        
        if let gameMode = self.gameInfo?.gameMode {
            gameData.gameType = gameMode.rawValue // Convert the GameMode enum to its raw String value
        } else {
            gameData.gameType = "Unknown"
        }

        do {
            try context.save()
        } catch let error {
            print("Failed to save game data: \(error)")
            // Optionally, show an alert to the user about the error
        }
    }


    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            print("Username is empty.")
            // Optionally, show an alert to the user about the missing username
            return
        }
        saveGameData(username: username)
//        fetchData() //Debug Core Data
    }
    
//    func fetchData() { ///// Debug Core Data
//        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
//
//        do {
//            let fetchedScores = try context.fetch(fetchRequest)
//            for score in fetchedScores {
//                print("Username: \(score.username ?? "Unknown")")
//                print("GameType: \(score.gameType ?? "Unknown")")
//                print("Score: \(score.score)")
//                print("-------------")
//            }
//        } catch let error {
//            print("Failed to fetch data: \(error)")
//        }
//    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let gameInfoMessage = gameInfo?.finalMessage {
            resultlabel.text = gameInfoMessage
            if let gameScore = gameInfo?.finalScore {
                scorelabel.text = "Score: \(gameScore)"
            }
        } else {
            resultlabel.text = gameResults
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // This method is called once 'return' key is pressed.
        textField.resignFirstResponder()  // Dismiss the keyboard.
        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        usernameTextField.delegate = self
    }
}
