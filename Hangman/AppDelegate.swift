

// AppDelegate.swift
// Hangman
//
// Created by William Workdesk on 2023-08-12.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    } ()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // This is the current version of your word list.
    // Increment this whenever you make changes to the word list.
    let currentWordListVersion = 2

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Check the stored version
        let storedVersion = UserDefaults.standard.integer(forKey: "WordListVersion")

        if storedVersion < currentWordListVersion {
            let sampleWords = [
                DictionaryWord(word: "Swift", hint: "A programming language developed by Apple."),
                   DictionaryWord(word: "Pendulum", hint: "A weight hung from a fixed point so that it can swing freely backward and forward."),
                   DictionaryWord(word: "Oxygen", hint: "An essential element we breathe in from the air."),
                   DictionaryWord(word: "Unicorn", hint: "A mythical creature often depicted as a horse with a single horn."),
                   DictionaryWord(word: "Galaxy", hint: "A system of millions or billions of stars, together with gas and dust, held together by gravitational attraction."),
                   DictionaryWord(word: "Neutron", hint: "A subatomic particle found in the nucleus of every atom."),
                   DictionaryWord(word: "Piano", hint: "A musical instrument played by means of a keyboard."),
                   DictionaryWord(word: "Satellite", hint: "An artificial body placed in orbit around a planet in order to collect information or for communication."),
                   DictionaryWord(word: "Jungle", hint: "An area of land overgrown with dense forest and tangled vegetation."),
                   DictionaryWord(word: "Volcano", hint: "A mountain or hill, typically conical, having a crater through which lava, rock fragments, hot vapor, and gas are or have been erupted from the earth's crust."),
                   DictionaryWord(word: "Penguin", hint: "A flightless bird native to the cold regions of the Southern Hemisphere."),
                   DictionaryWord(word: "Zodiac", hint: "A belt of the heavens within about 8° either side of the ecliptic, including all apparent positions of the sun, moon, and most familiar planets."),
            ]

                        WordManager.shared.saveWordsToDefaults(words: sampleWords)
                        UserDefaults.standard.set(currentWordListVersion, forKey: "WordListVersion")
                    }
                    
                    return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


