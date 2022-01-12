//
//  Movie.swift
//  MovieApp
//
//  Created by Sunil Zishan on 12.01.22.
//

import Foundation

struct MovieResponse: Codable {
    var page: Int?
    let results: [Movie]
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Hashable {
    
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(adult)
        hasher.combine(backdropPath)
        hasher.combine(genreIDS)
        hasher.combine(id)
        hasher.combine(originalLanguage)
        hasher.combine(originalTitle)
        hasher.combine(overview)
        hasher.combine(popularity)
        hasher.combine(posterPath)
        hasher.combine(releaseDate)
        hasher.combine(title)
        hasher.combine(video)
        hasher.combine(voteAverage)
        hasher.combine(voteCount)
    }
}

extension Movie {
    
    var posterFullPath: String {
        return "https://image.tmdb.org/t/p/w500\(self.posterPath ?? "")"
    }
    
    var backdropFullPath: String {
        return "https://image.tmdb.org/t/p/w500\(self.backdropPath ?? "")"
    }
}

