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
        
        tableView.rx.modelSelected(SearchSectionItem.self)
            .subscribe(onNext: { [weak self] item in
                
                switch item {
                case .recent(let entity):
                    guard let keyword = entity.keyword else { return }
                    self?.searchController.searchBar.text = keyword
                    reactor.action.onNext(.updateQuery(keyword))
                    reactor.action.onNext(.search(keyword))
                    
                case .autoComplete(let entity):
                    guard let keyword = entity.keyword else { return }
                    self?.searchController.searchBar.text = keyword
                    reactor.action.onNext(.search(keyword))
                    
                case .result(let repo):
                    let webVC = WebViewController(urlString: repo.htmlURL)
                    self?.navigationController?.pushViewController(webVC, animated: true)
                    
                case .loading, .empty:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        // 자동 더보기
        tableView.rx.contentOffset
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(reactor.state) { ($0, $1) }
            .filter { [weak self] offset, state in
                guard let self = self else { return false }

                let contentHeight = self.tableView.contentSize.height
                let frameHeight = self.tableView.frame.size.height
                let currentBottom = offset.y + frameHeight

                let triggerPoint = contentHeight * 0.7 // 화면의 70% 지점에서 동작하도록..

                return currentBottom > triggerPoint && !state.isLoading && state.hasNextPage
            }
            .map { _ in SearchViewReactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

private extension SearchViewController {
    func createDataSource(reactor: Reactor) -> RxTableViewSectionedReloadDataSource<SearchSection> {
        return .init(
            configureCell: { [weak self] dataSource, tableView, indexPath, sectionItem in
                
                switch sectionItem {
                case .recent(let entity):
                    let cell = tableView.dequeue(Reusable.searchRecentCell, for: indexPath)
                    cell.configure(with: entity, isSearching: false)
                    cell.deleteAction = { [weak self] in
                        guard let self, let keyword = entity.keyword else { return }
                        self.reactor?.action.onNext(.deleteRecent(keyword))
                    }
                    return cell
                    
                case .autoComplete(let entity):
                    let cell = tableView.dequeue(Reusable.searchRecentCell, for: indexPath)
                    cell.configure(with: entity, isSearching: true)
                    cell.deleteAction = nil
                    return cell
                    
                case .result(let repository):
                    let cell = tableView.dequeue(Reusable.searchResultCell, for: indexPath)
                    cell.configure(with: repository)
                    return cell
                    
                case .loading:
                    let cell = tableView.dequeue(Reusable.loadingCell, for: indexPath)
                    cell.configure()
                    return cell
                case .empty:
                    let cell = tableView.dequeue(Reusable.emptyCell, for: indexPath)
                    return cell
                }
            }
        )
    }
}

extension SearchViewController: UITableViewDelegate {
    //MARK: - Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let reactor = reactor else { return nil }
            let sections = reactor.currentState.sections
            guard section < sections.count else { return nil }

            switch sections[section] {

            case .recent(let items):
                guard !items.isEmpty else { return nil }
                let header = SearchHeaderView()
                header.configure(title: "최근 검색", style: .recent)
                return header

            case .autoComplete:
                return nil

            case .result:
                let header = SearchHeaderView()

                let totalCount = reactor.currentState.totalCount
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let formatted = formatter.string(from: NSNumber(value: totalCount)) ?? "0"

                header.configure(title: "\(formatted)개의 저장소", style: .result)
                return header
            }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let reactor = reactor else { return 0 }
        let sections = reactor.currentState.sections

        guard section < sections.count else { return 0 }

        switch sections[section] {
        case .recent(let items):
            return items.isEmpty ? 0 : 44
        case .autoComplete:
            return 0
        case .result:
            return 44
        }
    }

    //MARK: - Footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let reactor = reactor else { return nil }
        let sections = reactor.currentState.sections
        
        guard section < sections.count else { return nil }
        
        switch sections[section] {
        case .recent(let items):
            guard !items.isEmpty else { return nil }
            
            let footer = SearchRecentFooterView()
            footer.deleteAllAction = { [weak reactor] in
                reactor?.action.onNext(.deleteAllRecent)
            }
            return footer
            
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let reactor = reactor else { return 0 }
        let sections = reactor.currentState.sections
        
        guard section < sections.count else { return 0 }
        
        switch sections[section] {
        case .recent(let items):
            return items.isEmpty ? 0 : 44
        default:
            return 0
        }
    }
}
