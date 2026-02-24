//
//  SearchSection.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import RxDataSources

enum SearchSection {
    case recent([SearchSectionItem])
    case autoComplete([SearchSectionItem])
    case result([SearchSectionItem])
}

extension SearchSection: SectionModelType {
    typealias Item = SearchSectionItem
    
    var items: [SearchSectionItem] {
        switch self {
        case .recent(let items):
            return items
        case .autoComplete(let items):
            return items
        case .result(let items):
            return items
        }
    }
    
    init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .recent:
            self = .recent(items)
        case .autoComplete:
            self = .autoComplete(items)
        case .result:
            self = .result(items)
        }
    }
}

enum SearchSectionItem {
    case recent(RecentSearchEntity) // 검색리스트
    case autoComplete(RecentSearchEntity) // 자동완성
    case result(Repository) // 결과리스트
    case loading // 로딩
    case emptyRecent // 검색 없음
    case emptyResult // 결과 없음
}
