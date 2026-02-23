//
//  SearchViewController+Search.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/21/26.
//

import Foundation
import RxSwift
import ReactorKit
import UIKit
import RxCocoa

extension SearchViewController {
    // MARK: BindSearch
    func bindSearch(reactor: Reactor) {
        // 검색어 입력
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .map { text -> SearchViewReactor.Action in
                if text.isEmpty {
                    return .cancelSearch
                } else {
                    return .updateQuery(text)
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 검색 버튼 클릭
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { Reactor.Action.search($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 취소 버튼 클릭
        searchController.searchBar.rx.cancelButtonClicked
            .map { SearchViewReactor.Action.cancelSearch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
}
