//
//  DefaultMovieUseCase.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/16/24.
//

import Foundation
import RxSwift

protocol MovieListUseCase {
    func excute(type: MovieType, language: String, page: Int) -> Observable<Result<[Movie], Error>>
}

final class DefaultMovieUseCase: MovieListUseCase {
    private let repository: MovieRespository
    
    init(repository: MovieRespository) {
        self.repository = repository
    }
    
    func excute(type: MovieType, language: String, page: Int) -> Observable<Result<[Movie], Error>> {
        repository.fetchMovieList(type: type, language: language, page: page)
    }
}
