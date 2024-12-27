//
//  MovieListViewModel.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/16/24.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

struct MovieSection: SectionModelType {
    let section: Section
    var items: [Movie]
    
    init(section: Section, items: [Movie]) {
        self.section = section
        self.items = items
    }
    
    init(original: MovieSection, items: [Movie]) {
        self = original
        self.items = items
    }
}

final class MovieListViewModel {
    private let movieListUseCase: MovieListUseCase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadEvent: Observable<Void>
        let pullToRefresh: Observable<Void>
    }
    
    struct Output {
        let popularMovies = BehaviorRelay<[Movie]>(value: [])
        let nowPlayingMovies = BehaviorRelay<[Movie]>(value: [])
        let topRatedMovies = BehaviorRelay<[Movie]>(value: [])
        let upcomingMovies = BehaviorRelay<[Movie]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let error = PublishRelay<Error>()
    }
    
    init(movieListUseCase: MovieListUseCase) {
        self.movieListUseCase = movieListUseCase
    }
    
    func trasform(input: Input) -> Output {
        let output = Output()
        
        Observable.merge(
            input.viewDidLoadEvent,
            input.pullToRefresh
        )
        .flatMap { [weak self] _ -> Observable<Void> in
            guard let self = self else { return .empty() }
            return self.loadAllSections(
                popularMovies: output.popularMovies,
                nowPlayingMovies: output.nowPlayingMovies,
                topRatedMovies: output.topRatedMovies,
                upcomingMovies: output.upcomingMovies,
                isLoading: output.isLoading,
                error: output.error
            )
        }
        .subscribe()
        .disposed(by: disposeBag)
        
        return output
    }
    
    private func loadAllSections(
        popularMovies: BehaviorRelay<[Movie]>,
        nowPlayingMovies: BehaviorRelay<[Movie]>,
        topRatedMovies: BehaviorRelay<[Movie]>,
        upcomingMovies: BehaviorRelay<[Movie]>,
        isLoading: BehaviorRelay<Bool>,
        error: PublishRelay<Error>
    ) -> Observable<Void> {
        isLoading.accept(true)
        
        let movieTypes: [(MovieType, BehaviorRelay<[Movie]>)] = [
            (.popular, popularMovies),
            (.nowPlaying, nowPlayingMovies),
            (.topRated, topRatedMovies),
            (.upcoming, upcomingMovies)
        ]
        
        let observables = movieTypes.map { (type, relay) in
            fetchMovies(type: type)
                .do(onNext: { result in
                    if case .success(let movies) = result {
                        relay.accept(movies)
                    }
                    if case .failure(let err) = result {
                        error.accept(err)
                    }
                })
        }
        
        return Observable.zip(observables)
            .do(onCompleted: {
                isLoading.accept(false)
            })
            .map { _ in () }
    }
    
    private func fetchMovies(type: MovieType) -> Observable<Result<[Movie], Error>> {
        return movieListUseCase.excute(type: type, language: "ko-KR", page: 1)
    }
}
