//
//  MovieDownloader.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import Foundation


struct Movie: Decodable {
    let Title: String
    let Year: String
    let Director: String
    let imdbID: String
    
}

class MovieDownloader {
    

    
    static let shared = MovieDownloader()
    
    
    private let apiKey = "750448aa"
    
    func fetchMovieDetails(by id: String, completion: @escaping (Movie?) -> Void) {
        guard let url = URL(string: "https://www.omdbapi.com/?i=\(id)&apikey=\(apiKey)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let movie = try? decoder.decode(Movie.self, from: data) {
                    completion(movie)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}

