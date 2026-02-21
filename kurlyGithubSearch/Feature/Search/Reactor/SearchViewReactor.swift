//
//  SearchViewReactor.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

final class SearchViewReactor: Reactor {
    
    // MARK: - Action
    enum Action {
        case updateQuery(String)
        case search
        case selectRecent(String)
        case deleteRecent(String)
        case deleteAllRecent
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setQuery(String)
        case setRecent([RecentSearchEntity])
        case setAutoComplete([RecentSearchEntity])
        case setSearching(Bool)
        case setLoading(Bool)
    }
    
    // MARK: - State
    struct State {
        var query: String = ""
        var recentKeywords: [RecentSearchEntity] = []
        var autoCompleteKeywords: [RecentSearchEntity] = []
        var isSearching: Bool = false
        var isLoading: Bool = false
        var sections: [SearchSection] = []
    }
    
    // MARK: - Properties
    let localRepository: SearchLocalRepositoryType
    let initialState: State
    
    // MARK: - Init
    init(
        localRepository: SearchLocalRepositoryType
    ) {
        self.localRepository = localRepository
        
        let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)
        
        self.initialState = State(
            recentKeywords: recent,
            sections: [.recent(recent)]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case let .updateQuery(query):
            let autocomplete = query.isEmpty ? [] : localRepository.fetchAutocomplete(keyword: query)

            return .concat([
                .just(.setQuery(query)),
                .just(.setSearching(!query.isEmpty)),
                .just(.setAutoComplete(autocomplete))
            ])
            
        case .search:
            let query = currentState.query.trimmingCharacters(in: .whitespaces)
            guard !query.isEmpty else { return .empty() }

            localRepository.save(keyword: query)
            let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)

            return .concat([
                .just(.setSearching(false)),
                .just(.setAutoComplete([])),
                .just(.setRecent(recent))
            ])
            
        case let .selectRecent(keyword):
            return .concat([
                .just(.setQuery(keyword)),
                .just(.setSearching(true)),
                .just(.setLoading(true))
            ])
            
        case let .deleteRecent(keyword):
            localRepository.delete(keyword: keyword)
            let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)
            return .just(.setRecent(recent))
            
        case .deleteAllRecent:
            localRepository.deleteAll()
            return .just(.setRecent([]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setQuery(query):
            newState.query = query
            
        case let .setRecent(recent):
            newState.recentKeywords = recent
            
        case let .setAutoComplete(auto):
            newState.autoCompleteKeywords = auto
            
        case let .setSearching(isSearching):
            newState.isSearching = isSearching
            
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        
        if newState.isSearching {
            newState.sections = newState.autoCompleteKeywords.isEmpty ? [] : [.autoComplete(newState.autoCompleteKeywords)]
        } else {
            newState.sections = newState.recentKeywords.isEmpty ? [] : [.recent(newState.recentKeywords)]
        }
        return newState
    }
}
