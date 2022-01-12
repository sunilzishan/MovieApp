//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by Sunil Zishan on 12.01.22.
//

import Foundation

enum MAError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}


final class MovieViewModel {
    
    var movies: [Movie] = []
    var isPaginating = false
    var movieResponse: MovieResponse?

    static let baseURL = "https://api.themoviedb.org/3/discover/movie"
    private let urlString = baseURL + "?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3"
    
    func getMoivesListData(pagination: Bool = false, completed: @escaping (Result<Any, MAError>) -> Void) {
        if pagination {
            isPaginating = true
            let previousPage = movieResponse?.page ?? 1
            movieResponse?.page = previousPage + 1
        }
        guard let url = URL(string: pagination ? urlString + "&page=\(movieResponse?.page ?? 1)" : urlString) else {
            completed(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                self?.movieResponse = movieResponse
                self?.movies.append(contentsOf: movieResponse.results)
                completed(.success(movieResponse))
                if pagination {
                    self?.isPaginating = false
                }
                return
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
