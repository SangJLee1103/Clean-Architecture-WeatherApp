//
//  MovieRespository.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import Foundation
import RxSwift

protocol MovieRespository {
    func fetchMovieList(type: MovieType, language: String, page: Int) -> Observable<Result<[Movie], Error>>
    func searchMovie(title: String, language: String, page: Int) -> Observable<Result<[Movie], Error>>
}
