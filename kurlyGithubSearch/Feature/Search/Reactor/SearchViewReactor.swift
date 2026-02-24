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
        case updateQuery(String) // 검색 타이핑
        case search(String) // 검색버튼
        case deleteRecent(String) // 개별삭제
        case deleteAllRecent // 전체삭제
        
        case loadNextPage // 더보기
        case cancelSearch // 취소 이벤트
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
        let items = recent.map { SearchSectionItem.recent($0) }
        self.initialState = State(
            recentKeywords: recent,
            sections: recent.isEmpty ? [.recent([.emptyRecent])] : [.recent(items)]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            
        case let .updateQuery(query):
            if query.isEmpty {
                return mutate(action: .cancelSearch)
            }

            let autoComplete = localRepository.fetchAutocomplete(keyword: query)
            return .concat([
                .just(.setQuery(query)),
                .just(.setAutoComplete(autoComplete))
            ])
            
        case let .search(rawQuery): // 검색 이벤트
            let query = rawQuery.trimmingCharacters(in: .whitespaces)
            guard !query.isEmpty else { return .empty() }
            
            localRepository.save(keyword: query) // 최근검색에 저장
            
            if let cachedRepos = searchResultCache[query], let totalCount = totalCountCache[query] {
                return .concat([
                    .just(.setQuery(query)), 
                    .just(.setSearching(true)),
                    .just(.setRepositories(cachedRepos,
                                           totalCount: totalCount,
                                           page: 1,
                                           append: false))
                ])
            }
                        
            return .concat([
                .just(.setQuery(query)),
                .just(.setSearching(true)),
                .just(.setLoading(true)),
                .just(.setRepositories([], totalCount: 0, page: 1, append: false)),
                searchService.searchRepositories(keyword: query, page: 1)
                    .map { [weak self] response in
                        self?.searchResultCache[query] = response.items
                        self?.totalCountCache[query] = response.totalCount
                        return .setRepositories(response.items, totalCount: response.totalCount, page: 1, append: false)
                    }
                    .asObservable(),
                .just(.setLoading(false))
            ])
            
        case let .deleteRecent(keyword): // 개별삭제
            localRepository.delete(keyword: keyword)
            let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)
            return .just(.setRecent(recent))
            
        case .deleteAllRecent: // 전체삭제
            localRepository.deleteAll()
            return .just(.setRecent([]))
            
        case .loadNextPage: // 더보기
            guard !currentState.isLoading, currentState.hasNextPage else { return .empty() }
            
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
                    .asObservable(),
                    .just(.setLoading(false))
            ])
            
        case .cancelSearch: // 서치바 취소 이벤트
            let recent = localRepository.fetchRecent(count: Constant.recentFetchCount)

            return .concat([
                .just(.setQuery("")),
                .just(.setSearching(false)),
                .just(.setAutoComplete([])),
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
            newState.sections = makeSections(for: newState)

        case let .setAutoComplete(auto):
            newState.autoCompleteKeywords = auto
            newState.sections = makeSections(for: newState)

        case let .setSearching(isSearching):
            newState.isSearching = isSearching

        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            newState.sections = makeSections(for: newState)

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
            newState.sections = makeSections(for: newState)
        }
        return newState
    }
}

// MARK: - Section 생성
private extension SearchViewReactor {
    private func makeSections(for state: State) -> [SearchSection] {
        if state.isSearching { // 검색 실행 상태 → 결과 모드

            if state.isLoading {
                var items = state.repositories.map { SearchSectionItem.result($0) }
                if state.hasNextPage {
                    items.append(.loading)
                }
                return [.result(items)]
            }

            if !state.repositories.isEmpty { // 결과 모드
                var items = state.repositories.map { SearchSectionItem.result($0) }
                if state.hasNextPage { // 더보기
                    items.append(.loading)
                }
                return [.result(items)]
            }

            return [.result([.emptyResult])]
        }

        if !state.query.isEmpty { // 검색어는 있지만 아직 search 안 눌렀음 → autocomplete
            let items = state.autoCompleteKeywords.map { SearchSectionItem.autoComplete($0) }
            return [.autoComplete(items)]
        }

        // 최근 검색 리스트
        if state.recentKeywords.isEmpty { // 저장된 검색어 없음
            return [.recent([.emptyRecent])]
        } else { // 저장된 검색어 있음
            let items = state.recentKeywords.map { SearchSectionItem.recent($0) }
            return [.recent(items)]
        }
    }
}
