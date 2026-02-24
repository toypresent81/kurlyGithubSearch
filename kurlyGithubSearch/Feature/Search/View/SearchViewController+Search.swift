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
            .filter { !$0.isEmpty }
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 클리어버튼 이벤트
        searchController.searchBar.searchTextField.rx.controlEvent(.editingChanged)
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .filter { $0.isEmpty }
            .map { _ in SearchViewReactor.Action.cancelSearch }
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
        
        // 취소 버튼 이벤트
        searchController.searchBar.rx.cancelButtonClicked
            .map { SearchViewReactor.Action.cancelSearch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
}
