//
//  MovieRepository.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import Foundation
import RxSwift

final class DefaultMovieRepository {
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
}

extension DefaultMovieRepository: MovieRespository {
    func fetchMovieList(type: MovieType, language: String, page: Int) -> Observable<Result<[Movie], Error>> {
        movieService.fetchMovieList(type: type, language: language, page: page)
            .map { result in
                switch result {
                case .success(let response):
                    let movies = response.results.map { dto in
                        Movie(
                            title: dto.title,
                            overview: dto.overview,
                            posterPath: dto.posterPath ?? "",
                            voteAverage: dto.voteAverage
                        )
                    }
                    return .success(movies)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
