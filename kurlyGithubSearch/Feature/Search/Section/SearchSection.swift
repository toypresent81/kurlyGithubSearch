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
}

extension SearchSection: SectionModelType {
    typealias Item = SearchSectionItem
    
    var items: [SearchSectionItem] {
        switch self {
        case .recent(let items):
            return items.map { .recent($0) }
        case .autoComplete(let items):
            return items.map { .autoComplete($0) }
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
        }
    }
}

enum SearchSectionItem {
    case recent(RecentSearchEntity)
    case autoComplete(RecentSearchEntity)
}
