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
    var movieResponse: MovieResponse?
    //TODO: move to config
    static let baseURL = "https://api.themoviedb.org/3/discover/movie"
    private let urlString = baseURL + "?api_key=c9856d0cb57c3f14bf75bdc6c063b8f3"
    
    func getMoivesListData(pagination: Bool = false, completed: @escaping (Result<Any, MAError>) -> Void) {

        guard let url = URL(string: urlString) else {
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
                return
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
