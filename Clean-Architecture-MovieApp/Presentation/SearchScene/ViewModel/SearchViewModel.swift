//
//  SearchViewModel.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 2/1/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    private let searchUseCase: SearchUseCase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let movieText: Observable<String>
        let loadNextPage: Observable<Void>
        let searchControllerIsActive: Observable<Bool>
    }
    
    struct Output {
        let movies: BehaviorRelay<[Movie]>
        let isLoading: BehaviorRelay<Bool>
        let error: PublishRelay<Error>
        let isSearchMode: Observable<Bool>
        
    }
    
    init(searchUseCase: SearchUseCase) {
        self.searchUseCase = searchUseCase
    }
    
    func transform(input: Input) -> Output {
        let movies =  BehaviorRelay<[Movie]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let error = PublishRelay<Error>()
        let currentPage = BehaviorRelay<Int>(value: 1)
        
        let isSearchMode = Observable.combineLatest(
            input.searchControllerIsActive,
            input.movieText
        ) { isActive, text in
            return isActive && !text.isEmpty
        }
        
        input.movieText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .do(onNext: { _ in
                isLoading.accept(true)
                currentPage.accept(1)
                movies.accept([])
            })
            .flatMapLatest { [weak self] text in
                self?.searchUseCase.search(
                    title: text,
                    language: "ko-KR",
                    page: currentPage.value
                ) ?? .empty()
            }
            .do(onNext: { _ in
                isLoading.accept(false)
            })
            .subscribe(onNext: { result in
                switch result {
                case .success(let newMovies):
                    movies.accept(newMovies)
                case .failure(let err):
                    error.accept(err)
                }
            })
            .disposed(by: disposeBag)
        
        input.loadNextPage
            .withLatestFrom(input.movieText)
            .filter { !$0.isEmpty }
            .withLatestFrom(isLoading) { ($0, $1) }
            .filter { !$1 }
            .map { $0.0 }
            .do(onNext: { _ in
                isLoading.accept(true)
                currentPage.accept(currentPage.value + 1)
            })
            .flatMapLatest { [weak self] text in
                self?.searchUseCase.search(
                    title: text,
                    language: "ko-KR",
                    page: currentPage.value
                ) ?? .empty()
            }
            .do(onNext: { _ in
                isLoading.accept(false)
            })
            .subscribe(onNext: { result in
                switch result {
                case .success(let newMovies):
                    let currentMovies = movies.value
                    movies.accept(currentMovies + newMovies)
                case .failure(let err):
                    error.accept(err)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            movies: movies,
            isLoading: isLoading,
            error: error,
            isSearchMode: isSearchMode
        )
    }
}
