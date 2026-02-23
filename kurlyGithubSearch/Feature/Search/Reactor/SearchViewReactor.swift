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
        case deleteRecent(String)
        case deleteAllRecent
        
        case loadNextPage
        case cancelSearch
    }
    
    // MARK: - Mutation
    enum Mutation {
        case setQuery(String)
        case setRecent([RecentSearchEntity])
        case setAutoComplete([RecentSearchEntity])
        case setSearching(Bool)
        case setLoading(Bool)
        
        case setRepositories([Repository], totalCount: Int, page: Int, append: Bool)
    }
    
    // MARK: - State
    struct State {
        var query: String = ""
        var recentKeywords: [RecentSearchEntity] = []
        var autoCompleteKeywords: [RecentSearchEntity] = []
        var isSearching: Bool = false
        var isLoading: Bool = false
        var sections: [SearchSection] = []
        
        var repositories: [Repository] = []
        var totalCount: Int = 0
        var page: Int = 1
        var hasNextPage: Bool = false
    }
    
    // MARK: - Properties
    let localRepository: SearchLocalRepositoryType
    private let searchService: SearchServiceType
    
    private var searchResultCache: [String: [Repository]] = [:]
    private var totalCountCache: [String: Int] = [:]
    
    let initialState: State
    
    // MARK: - Init
    init(
        localRepository: SearchLocalRepositoryType,
        searchService: SearchServiceType
    ) {
        self.localRepository = localRepository
        self.searchService = searchService
        
        let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)
        
        self.initialState = State(
            recentKeywords: recent,
            sections: [.recent(recent)]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case let .updateQuery(query):
            if query.isEmpty { // 검색어 지울 경우
                let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)
                return .concat([
                    .just(.setQuery(query)),
                    .just(.setSearching(false)),
                    .just(.setRepositories([], totalCount: 0, page: 1, append: false)),
                    .just(.setRecent(recent))
                ])
            } else {
                let autoComplete = localRepository.fetchAutocomplete(keyword: query)
                return .concat([
                    .just(.setQuery(query)),
                    .just(.setSearching(true)),
                    .just(.setAutoComplete(autoComplete))
                ])
            }
            
        case .search:
            let query = currentState.query.trimmingCharacters(in: .whitespaces)
            guard !query.isEmpty else { return .empty() }
            
            localRepository.save(keyword: query) // 최근검색에 저장
            
            if let cachedRepos = searchResultCache[query], let totalCount = totalCountCache[query] { // 캐시확인
                return .just(.setRepositories(cachedRepos, totalCount: totalCount, page: 1, append: false))
            }
            
            return .concat([
                .just(.setSearching(true)),
                .just(.setLoading(true)),
                .just(.setRepositories([], totalCount: 0, page: 1, append: false)),
                
                searchService.searchRepositories(keyword: query, page: 1)
                    .map { [weak self] response in
                        self?.searchResultCache[query] = response.items
                        self?.totalCountCache[query] = response.totalCount
                        return .setRepositories(response.items, totalCount: response.totalCount, page: 1, append: false)
                    }
                    .asObservable()
            ])
            
        case let .deleteRecent(keyword):
            localRepository.delete(keyword: keyword)
            let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)
            return .just(.setRecent(recent))
            
        case .deleteAllRecent:
            localRepository.deleteAll()
            return .just(.setRecent([]))
            
        case .loadNextPage:
            
            guard !currentState.isLoading, currentState.hasNextPage else {
                return .empty()
            }
            
            let nextPage = currentState.page + 1
            let query = currentState.query
            
            return .concat([
                .just(.setLoading(true)),
                
                searchService.searchRepositories(keyword: query, page: nextPage)
                    .map { response in
                        Mutation.setRepositories(
                            response.items,
                            totalCount: response.totalCount,
                            page: nextPage,
                            append: true
                        )
                    }
                    .asObservable()
            ])
        case .cancelSearch: // 서치바 취소 이벤트

            let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)

            return .concat([
                .just(.setQuery("")),
                .just(.setSearching(false)),
                .just(.setRepositories([], totalCount: 0, page: 1, append: false)),
                .just(.setRecent(recent))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setQuery(query):
            newState.query = query
            
        case let .setRecent(recent):
            newState.recentKeywords = recent
            if !newState.isSearching {
                newState.sections = recent.isEmpty ? [] : [.recent(recent)]
            }
            
        case let .setAutoComplete(auto):
            newState.autoCompleteKeywords = auto
            if newState.isSearching {
                newState.sections = auto.isEmpty ? [] : [.autoComplete(auto)]
            }
            
        case let .setSearching(isSearching):
            newState.isSearching = isSearching

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
            makeResultSection(state: &newState)            
            
        case let .setRepositories(repos, totalCount, page, append):
            if append {
                newState.repositories += repos
            } else {
                newState.repositories = repos
                newState.totalCount = totalCount
            }
            
            newState.page = page

            let maxCount = min(totalCount, 1000) // 검색 1000개 제한때문에 설정
            newState.hasNextPage = newState.repositories.count < maxCount

            newState.isLoading = false
            makeResultSection(state: &newState)
        }
        
        return newState
    }
    
    private func makeResultSection(state: inout State) {
        var items = state.repositories.map {
            SearchSectionItem.result($0)
        }

        if state.isLoading && state.hasNextPage {
            items.append(.loading)
        }

        state.sections = [.result(items)]
    }
}
