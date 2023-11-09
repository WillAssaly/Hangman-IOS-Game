import UIKit
import CoreData  // Ensure you import CoreData

// This controller handles the end game scenarios, displaying results and saving game data.
class EndGameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var resultlabel: UILabel!             // Displays the result of the game (win/lose).
    @IBOutlet weak var scorelabel: UILabel!             // Displays the final score of the game.
    @IBOutlet weak var usernameTextField: UITextField! // Input field for the user's name.
    
    // MARK: - Properties
    var gameResults: String?              // A string representing the game's result.
    var gameInfo: EndOfGameInformation?  // A struct containing the game's end information.
    
    // Access the Core Data context from the AppDelegate to save game data.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Actions
    // Action to start a new game, triggered when the "Play Again" button is tapped.
    @IBAction func playAgainTapped(_ sender: UIButton) {
        guard let navigationController = self.navigationController else {  // Attempt to navigate back to the initial game selection screen.
            self.dismiss(animated: true, completion: nil)                 // If not within a navigation controller, simply dismiss the current view.
            return
        }
        
        // Navigate to either the Films or Dictionary selection screen based on the game mode.
        if let filmsViewController = navigationController.viewControllers.first(where: { $0 is FilmsViewController }) {
            
                                                                   // If coming from the Films game mode, fetch and display a new hint.
            (filmsViewController as? FilmsViewController)?.fetchAndDisplayHint()
            navigationController.popToViewController(filmsViewController, animated: true)
        } else if let dictionaryViewController = navigationController.viewControllers.first(where: { $0 is DictionaryViewController }) {
            
                                                              // If coming from the Dictionary game mode, fetch and display a new word.
            (dictionaryViewController as? DictionaryViewController)?.fetchAndDisplayNewWord()
            navigationController.popToViewController(dictionaryViewController, animated: true)
        }
    }
    
                                                      // Saves the game data to Core Data with the given username.
    func saveGameData(username: String) {
        
                                                   // Create a new instance of the Core Data Score entity.
        let gameData = NSEntityDescription.insertNewObject(forEntityName: "Score", into: context) as! Score // Make sure your entity's name matches here if it's not "DataModel"
                                                // Populate the Score entity with data from the game.
        gameData.username = username
        gameData.score = Int16(JeuPendu.shared.score)
        
                                            // Save the type of game that was played.
        
        if let gameMode = self.gameInfo?.gameMode {
            
                                         // Use the raw value of the GameMode enum.
            gameData.gameType = gameMode.rawValue
        } else {                       // Use a default value if the game mode is not known.
            gameData.gameType = "Unknown"
        }

                                   // Attempt to save the context, handling any errors.
        do {
            try context.save()
        } catch let error {
            print("Failed to save game data: \(error)")
            // Optionally, show an alert to the user about the error
        }
    }

    // Action to save the game data, triggered when the "Save" button is tapped.
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        // Ensure the username field is not empty before saving.
        guard let username = usernameTextField.text, !username.isEmpty else {
            print("Username is empty.")
            return
        }
        saveGameData(username: username)
    }
    

    // MARK: - Lifecycle
    // Called when the view has appeared fully.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
                                                            // Display the final messages and score when the view appears.
        if let gameInfoMessage = gameInfo?.finalMessage {
            resultlabel.text = gameInfoMessage
            if let gameScore = gameInfo?.finalScore {
                scorelabel.text = "Score: \(gameScore)"
            }
        } else {
            resultlabel.text = gameResults
        }
    }
                                                               // Dismiss the keyboard when the return key is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()                     // Dismiss the keyboard.
        return true
    }

                                                         // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
                                                      // Hide the back button to prevent navigation during end game sequence.
        self.navigationItem.hidesBackButton = true
                                                    // Set the text field's delegate to handle return key events.
        usernameTextField.delegate = self
    }
}
