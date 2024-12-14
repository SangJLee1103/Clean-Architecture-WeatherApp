//
//  APIRequestInterceptor.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import Foundation
import Alamofire

final class APIRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        
        urlRequest.headers.add(.accept("application/json"))
        urlRequest.headers.add(.init(name: "Authorization", value: "Bearer \(Config.Network.apiKey)"))
        
        completion(.success(urlRequest))
    }
}
