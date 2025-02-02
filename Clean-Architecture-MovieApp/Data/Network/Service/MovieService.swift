//
//  MovieService.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import Foundation
import Alamofire
import RxSwift

protocol MovieServiceProtocol {
    func fetchMovieList(type: MovieType, language: String, page: Int) -> Observable<Result<MovieResponseDTO, Error>>
    func searchMovie(title: String, language: String, page: Int) -> Observable<Result<MovieResponseDTO, Error>>
}

final class MovieService: MovieServiceProtocol {
    static let shared = MovieService()
    private let session: Session
    
    init(session: Session = NetworkManager.shared.session) {
        self.session = session
    }
    
        
    func fetchMovieList(type: MovieType, language: String, page: Int) -> Observable<Result<MovieResponseDTO, Error>> {
        let url = "\(Config.Endpoint.movie)/\(type.endpoint)"
        
        let parameter: [String: Any] = [
            "language": language,
            "page": page
        ]
        
        return Observable.create { observer in
            self.session.request(url, method: .get, parameters: parameter)
                .validate()
                .responseDecodable(of: MovieResponseDTO.self) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        observer.onNext(.success(movieResponse))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onNext(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
    
    func searchMovie(title: String, language: String, page: Int) -> Observable<Result<MovieResponseDTO, any Error>> {
        let url = Config.Endpoint.search
            
        let parameter: [String: Any] = [
            "query": title,
            "language": language,
            "page": page
        ]
        
        return Observable.create { observer in
            self.session.request(url, method: .get, parameters: parameter)
                .validate()
                .responseDecodable(of: MovieResponseDTO.self) { response in
                    switch response.result {
                    case .success(let movieResponse):
                        observer.onNext(.success(movieResponse))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onNext(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
