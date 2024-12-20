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
        let popularMovies: BehaviorRelay<[Movie]>
        let nowPlayingMovies: BehaviorRelay<[Movie]>
        let topRatedMovies: BehaviorRelay<[Movie]>
        let upcomingMovies: BehaviorRelay<[Movie]>
        let isLoading: BehaviorRelay<Bool>
        let error: PublishRelay<Error>
    }
    
    init(movieListUseCase: MovieListUseCase) {
        self.movieListUseCase = movieListUseCase
    }
    
    func trasform(input: Input) -> Output {
        let popularMovies = BehaviorRelay<[Movie]>(value: [])
        let nowPlayingMovies = BehaviorRelay<[Movie]>(value: [])
        let topRatedMovies = BehaviorRelay<[Movie]>(value: [])
        let upcomingMovies = BehaviorRelay<[Movie]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let error = PublishRelay<Error>()
        
        Observable.merge(
            input.viewDidLoadEvent,
            input.pullToRefresh
        )
        .flatMap { [weak self] _ -> Observable<Void> in
            guard let self = self else { return .empty() }
            return self.loadAllSections(
                popularMovies: popularMovies,
                nowPlayingMovies: nowPlayingMovies,
                topRatedMovies: topRatedMovies,
                upcomingMovies: upcomingMovies,
                isLoading: isLoading,
                error: error
            )
        }
        .subscribe()
        .disposed(by: disposeBag)
        
        return Output(
            popularMovies: popularMovies,
            nowPlayingMovies: nowPlayingMovies,
            topRatedMovies: topRatedMovies,
            upcomingMovies: upcomingMovies,
            isLoading: isLoading,
            error: error
        )
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
        
        let popular = fetchMovies(type: .popular)
            .do(onNext: { result in
                if case .success(let movies) = result {
                    popularMovies.accept(movies)
                }
            })
        
        let nowPlaying = fetchMovies(type: .nowPlaying)
            .do(onNext: { result in
                if case .success(let movies) = result {
                    nowPlayingMovies.accept(movies)
                }
            })
        
        let topRated = fetchMovies(type: .topRated)
            .do(onNext: { result in
                if case .success(let movies) = result {
                    topRatedMovies.accept(movies)
                }
            })
        
        let upcoming = fetchMovies(type: .upcoming)
            .do(onNext: { result in
                if case .success(let movies) = result {
                    upcomingMovies.accept(movies)
                }
            })
        
        return Observable.zip(popular, nowPlaying, topRated, upcoming)
            .do(
                onNext: { (popularResult, nowPlayingResult, topRatedResult, upcomingResult) in
                    if case .failure(let err) = popularResult {
                        error.accept(err)
                    }
                    if case .failure(let err) = nowPlayingResult {
                        error.accept(err)
                    }
                    if case .failure(let err) = topRatedResult {
                        error.accept(err)
                    }
                    if case .failure(let err) = upcomingResult {
                         error.accept(err)
                    }
                },
                onCompleted: {
                    isLoading.accept(false)
                }
            )
            .map { _ in () }
    }
    
    private func fetchMovies(type: MovieType) -> Observable<Result<[Movie], Error>> {
        return movieListUseCase.excute(type: type, language: "ko-KR", page: 1)
    }
}
