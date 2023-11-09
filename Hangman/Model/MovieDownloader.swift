//
//  MovieDownloader.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

import Foundation

// Represents a movie with its title, year, director, and IMDb ID.
struct Movie: Decodable {
    let Title: String
    let Year: String
    let Director: String
    let imdbID: String
    
}

// Manages the downloading of movie details from an online database.
class MovieDownloader {
    

    static let shared = MovieDownloader()     // Singleton instance to be used throughout the app.
    private let apiKey = "750448aa"         // The API key for accessing the movie database.
    
    // Fetches movie details from the OMDb API using a movie's IMDb ID.
    func fetchMovieDetails(by id: String, completion: @escaping (Movie?) -> Void) {
        // Construct the URL for the API request using the given IMDb ID and the stored API key.
        guard let url = URL(string: "https://www.omdbapi.com/?i=\(id)&apikey=\(apiKey)") else {
            completion(nil)                     // Call completion handler with nil if URL is not valid.
            return
        }
        
        // Create a data task to fetch the details from the URL.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Check if data was received.
            if let data = data {
                let decoder = JSONDecoder()
                                           // Attempt to decode the data into a Movie object.
                if let movie = try? decoder.decode(Movie.self, from: data) {
                    completion(movie)    // Pass the movie object to the completion handler.
                } else {
                    completion(nil)    // Pass nil to the completion handler if decoding fails.
                }
            } else {
                completion(nil)     // Pass nil to the completion handler if no data is received.
            }
        }
        
        task.resume()           // Start the task to fetch the data.
    }
}

