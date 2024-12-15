//
//  MovieResponseDTO.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import Foundation

enum MovieType {
    case popular
    case nowPlaying
    case topRated
    case upcoming
    
    var endpoint: String {
        switch self {
        case .popular: return "popular"
        case .nowPlaying: return "now_playing"
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
