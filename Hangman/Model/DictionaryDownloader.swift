//
//  DictionaryDownloader.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-26.
//

import Foundation

// Represents a word and its corresponding hint.
struct DictionaryWord: Codable {
    let word: String
    let hint: String
}
   // Manages the retrieval and storage of dictionary words for the game.
    class WordManager {
        
        static let shared = WordManager()         // Singleton instance for global access throughout the app.
        private let wordsKey = "DictionaryWords" // Key used to save and retrieve words from UserDefaults.
        private init() {}                       // Private initializer to enforce singleton usage.

        
        // Saves an array of DictionaryWord to UserDefaults.
        func saveWordsToDefaults(words: [DictionaryWord]) {
            if let encodedData = try? JSONEncoder().encode(words) {            // Attempt to encode the array into JSON data.
                UserDefaults.standard.setValue(encodedData, forKey: wordsKey) // Save the encoded JSON data in UserDefaults under the specified key.

            }
        }
        
        // Retrieves and decodes an array of DictionaryWord from UserDefaults.
        func getWordsFromDefaults() -> [DictionaryWord]? {
            if let savedData = UserDefaults.standard.data(forKey: wordsKey),             // Check if UserDefaults contains data for the specified key.
                                                                                       // Attempt to decode the JSON data back into an array of DictionaryWord.
               let decodedWords = try? JSONDecoder().decode([DictionaryWord].self, from: savedData) {
                return decodedWords
            }
            return nil
        }
        
        // Returns a random DictionaryWord from the stored array, if available.
        func getRandomWord() -> DictionaryWord? {
            guard let words = getWordsFromDefaults() else { return nil } // Retrieve the array of words from UserDefaults.
            return words.randomElement()                                // Return a random element from the array.
        }
    }

