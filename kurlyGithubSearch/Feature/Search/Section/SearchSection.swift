//
//  SearchSection.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import RxDataSources

enum SearchSection {
    case recent([RecentSearchEntity])
    case autoComplete([RecentSearchEntity])
    case result([SearchSectionItem])
}

extension SearchSection: SectionModelType {
    typealias Item = SearchSectionItem
    
    var items: [SearchSectionItem] {
        switch self {
        case .recent(let items):
            return items.map { .recent($0) }
        case .autoComplete(let items):
            return items.map { .autoComplete($0) }
        case .result(let items):
            return items
        }
    }
    
    init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .recent:
            self = .recent(items.compactMap {
                if case let .recent(entity) = $0 { return entity }
                return nil
            })
        case .autoComplete:
            self = .autoComplete(items.compactMap {
                if case let .autoComplete(entity) = $0 { return entity }
                return nil
            })
        case .result:
            self = .result(items)
        }
    }
}

enum SearchSectionItem {
    case recent(RecentSearchEntity)
    case autoComplete(RecentSearchEntity)
    case result(Repository)
    case loading
}
