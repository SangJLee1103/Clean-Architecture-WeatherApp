//
//  DefaultSearchUseCase.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 1/19/25.
//

import Foundation
import RxSwift

protocol SearchUseCase {
    func search(title: String, language: String, page: Int) -> Observable<Result<[Movie], Error>>
}

final class DefaultSearchUseCase: SearchUseCase {
    private let repository: MovieRespository
    
    init(repository: MovieRespository) {
        self.repository = repository
    }
    
    func search(title: String, language: String, page: Int) ->  Observable<Result<[Movie], any Error>> {
        repository.searchMovie(title: title, language: language, page: page)
    }
}
