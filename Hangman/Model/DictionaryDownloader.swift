//
//  DictionaryDownloader.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-26.
//

import Foundation

struct DictionaryWord: Codable {
    let word: String
    let hint: String
}

    class WordManager {
        
        static let shared = WordManager()
        private let wordsKey = "DictionaryWords"
        
        private init() {}
        
        func saveWordsToDefaults(words: [DictionaryWord]) {
            if let encodedData = try? JSONEncoder().encode(words) {
                UserDefaults.standard.setValue(encodedData, forKey: wordsKey)
            }
        }
        
        func getWordsFromDefaults() -> [DictionaryWord]? {
            if let savedData = UserDefaults.standard.data(forKey: wordsKey),
               let decodedWords = try? JSONDecoder().decode([DictionaryWord].self, from: savedData) {
                return decodedWords
            }
            return nil
        }
        
        func getRandomWord() -> DictionaryWord? {
            guard let words = getWordsFromDefaults() else { return nil }
            return words.randomElement()
        }
    }

