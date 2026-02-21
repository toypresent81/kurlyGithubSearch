//
//  SearchViewController+TableView.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import ReusableKit

extension SearchViewController {
    // MARK: BindTableView
    func bindTableView(reactor: Reactor) {
        let dataSource = self.createDataSource(reactor: reactor)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

private extension SearchViewController {
    func createDataSource(reactor: Reactor) -> RxTableViewSectionedReloadDataSource<SearchSection> {
        return .init(
            configureCell: { [weak self] dataSource, tableView, indexPath, sectionItem in
                let cell = tableView.dequeue(Reusable.searchRecentCell, for: indexPath)
                
                switch sectionItem {
                case .recent(let entity):
                    cell.configure(with: entity, isSearching: false)
                    cell.deleteAction = {
                        guard let keyword = entity.keyword else { return }
                        self?.reactor?.action.onNext(.deleteRecent(keyword))
                    }
                    
                case .autoComplete(let entity):
                    cell.configure(with: entity, isSearching: true)
                    cell.deleteAction = nil
                }
                
                return cell
            }
        )
    }
}

extension SearchViewController: UITableViewDelegate {
    //MARK: - Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let reactor = reactor else { return nil }
        let state = reactor.currentState

        guard !state.isSearching,
              !state.recentKeywords.isEmpty else { return nil }

        return SearchRecentHeaderView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let reactor = reactor else { return 0 }
        let state = reactor.currentState

        return (!state.isSearching && !state.recentKeywords.isEmpty) ? 44 : 0
    }

    //MARK: - Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let reactor = reactor else { return nil }
        let state = reactor.currentState

        guard !state.isSearching,
              !state.recentKeywords.isEmpty else { return nil }

        let footer = SearchRecentFooterView()
        footer.deleteAllAction = { [weak reactor] in
            reactor?.action.onNext(.deleteAllRecent)
        }
        return footer
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let reactor = reactor else { return 0 }
        let state = reactor.currentState

        return (!state.isSearching && !state.recentKeywords.isEmpty) ? 44 : 0
    }
}
