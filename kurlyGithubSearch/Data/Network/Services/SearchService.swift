//
//  SearchService.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import Foundation
import Alamofire

import RxSwift

protocol SearchServiceType {
    func searchRepositories(keyword: String, page: Int) -> Single<SearchRepositoryResponse>
}

final class SearchService: SearchServiceType {
    
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
    
    func searchRepositories(
        keyword: String,
        page: Int
    ) -> Single<SearchRepositoryResponse> {
        
        let url = DOMAIN.GIT + SEARCH.repository
        
        let parameters: Parameters = [
            "q": keyword,
            "page": page,
            "per_page": 100
        ]
        
        return networkManager.request(
            url,
            method: .get,
            parameters: parameters,
            headers: nil
        )
    }
}
