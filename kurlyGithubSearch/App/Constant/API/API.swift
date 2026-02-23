//
//  EndPoint.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/21/26.
//

import Foundation

struct DOMAIN {
    static let GIT: String = "https://api.github.com"
}

struct SEARCH {
    static let repository = "/search/repositories"
    
    // [GET] https://api.github.com/search/repositories?q={keyword}&page={page}
}
