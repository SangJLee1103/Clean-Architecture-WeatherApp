//
//  MovieDetailViewModel.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/17/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MovieDetailViewModel {
    private let disposeBag = DisposeBag()
    private let movie: Movie
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
    }
    
    struct Output {
        let backdropPath: Driver<String>
        let posterPath: Driver<String>
        let title: Driver<String>
        let releaseDate: Driver<String>
        let average: Driver<Double>
        let overview: Driver<String>
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func trasform(input: Input) -> Output {
        let movieData = input.viewDidLoadEvent
            .map { [weak self] _ in self?.movie }
            .compactMap { $0 }
        
        let backgroundPath = movieData.map { $0.backdropPath }.asDriver(onErrorJustReturn: "")
        let posterPath = movieData.map { $0.posterPath }.asDriver(onErrorJustReturn: "")
        let title = movieData.map { $0.title }.asDriver(onErrorJustReturn: "")
        let releaseDate = movieData.map { $0.releaseDate }.asDriver(onErrorJustReturn: "")
        let average = movieData.map { $0.voteAverage }.asDriver(onErrorJustReturn: 0.0)
        let overview = movieData.map { $0.overview }.asDriver(onErrorJustReturn: "")
        
        return Output(
            backdropPath: backgroundPath,
            posterPath: posterPath,
            title: title,
            releaseDate: releaseDate,
            average: average,
            overview: overview
        )
    }
    
}
