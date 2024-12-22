//
//  NetworkManager.swift
//  Clean-Architecture-MovieApp
//
//  Created by 이상준 on 12/14/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    let session: Session
    
    private init() {
        let interceptor = APIRequestInterceptor()
        self.session = Session(interceptor: interceptor)
    }
}
