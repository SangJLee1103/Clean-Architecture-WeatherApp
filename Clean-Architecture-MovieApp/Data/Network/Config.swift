//
//  Config.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import Foundation

enum Config {
    enum Network {
        static let apiKey = Bundle.main.infoDictionary?["TMDB_API_KEY"] as! String
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dict
    }()
}

extension Config {
    static let baseURL: String = "https://api.themoviedb.org/3/movie"
}
