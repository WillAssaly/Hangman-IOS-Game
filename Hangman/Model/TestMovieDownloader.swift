//
//  TestMovieDownloader.swift
//  Hangman
//
//  Created by William Workdesk on 2023-08-12.
//

//import Foundation
//
//
//struct Movie: Decodable {
//    let Title: String
//}
//
//class MovieDownloader {
//    
//    static let shared = MovieDownloader()
//    
//    private let apiKey = "750448aa"
//    
//    func fetchMovieDetails(by id: String, completion: @escaping (Movie?) -> Void) {
//        guard let url = URL(string: "https://www.omdbapi.com/?i=\(id)&apikey=\(apiKey)") else {
//            completion(nil)
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                let decoder = JSONDecoder()
//                if let movie = try? decoder.decode(Movie.self, from: data) {
//                    completion(movie)
//                } else {
//                    completion(nil)
//                }
//            } else {
//                completion(nil)
//            }
//        }
//        
//        task.resume()
//    }
//}
//
//
//let listFilms = ["tt0988045",
//                 "tt0962736",
//                 "tt0499549",
//                 "tt0963178",
//                 "tt0830515",
//                 "tt0879870",
//                 "tt0472399",
//                 "tt0361748",
//                 "tt0817230",
//                 "tt0844479",
//                 "tt0862467",
//                 "tt0475290",
//                 "tt0821642",
//                 "tt0489049"]
//
//func fetchRandomMovieAndPrintTitle() {
//    
//    let randomFilmID = listFilms.randomElement()!
//    
//    MovieDownloader.shared.fetchMovieDetails(by: randomFilmID) { movie in
//        if let movie = movie {
//            print("Random Movie Title: \(movie.Title)")
//        } else {
//            print("Failed to fetch movie details.")
//        }
//        
//        // Important: Exit the process after fetching to prevent script from hanging
//        exit(0)
//    }
//}
//
//// Entry point for our script
//func main() {
//    fetchRandomMovieAndPrintTitle()
//    RunLoop.current.run()
//}
//
//// Call the main function to start the script
//main()
