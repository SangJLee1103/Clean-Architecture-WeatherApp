//
//  MovieResponseDTO.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import Foundation

enum MovieType {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    
    var endpoint: String {
        switch self {
        case .nowPlaying: return "now_playing"
        case .popular: return "popular"
        case .topRated: return "top_rated"
        case .upcoming: return "upcoming"
        }
    }
}

struct MovieResponseDTO: Decodable {
    let results: [MovieDTO]
}

struct MovieDTO: Decodable {
    let originalTitle: String
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case originalTitle = "original_title"
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
