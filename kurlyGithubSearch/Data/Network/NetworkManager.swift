//
//  NetworkManager.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import Foundation
import Alamofire
import RxSwift

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError(Int)
    case underlying(Error)
}

protocol NetworkManagerType {
    func request<T: Decodable>(
        _ url: String,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?
    ) -> Single<T>
}

final class NetworkManager: NetworkManagerType {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func request<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) -> Single<T> {
        
        return Single.create { single in
            
            guard let url = URL(string: url) else {
                single(.failure(NetworkError.invalidURL))
                return Disposables.create()
            }
            
            let request = self.session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: headers
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                
                switch response.result {
                case .success(let value):
                    single(.success(value))
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        single(.failure(NetworkError.serverError(statusCode)))
                    } else {
                        single(.failure(NetworkError.underlying(error)))
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
