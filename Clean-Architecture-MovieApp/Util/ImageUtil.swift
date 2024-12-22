//
//  DefaultImageService.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/18/24.
//

import Foundation

struct ImageUtil {
    static func getPosterURL(path: String) -> URL? {
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let fullURL = baseURL + path
        return URL(string: fullURL)
    }
}
