//
//  SearchRepositoryResponse.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import Foundation

struct SearchRepositoryResponse: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Repository: Decodable {
    let id: Int
    let name: String
    let owner: Owner
    let htmlURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case htmlURL = "html_url"
    }
}

struct Owner: Decodable {
    let login: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
