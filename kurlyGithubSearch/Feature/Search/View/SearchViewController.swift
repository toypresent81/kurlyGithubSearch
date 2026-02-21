//
//  SearchViewController.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import SnapKit
import Then
import ReusableKit
import RxSwift
import ReactorKit
import RxCocoa

final class SearchViewController: UIViewController {
            
    typealias Reactor = SearchViewReactor
    //MARK: - UI
    lazy var tableView = BaseTableView().then {
        $0.register(Reusable.searchRecentCell)
    }
    struct Reusable {
        static let searchRecentCell = ReusableCell<SearchRecentCell>()
    }

    lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "저장소 검색"
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.tintColor = .systemPurple
    }
        
    // MARK: Rx
    var disposeBag = DisposeBag()

    // MARK: - Initializing
    init() {
        let localRepository = SearchLocalRepository()
        defer { self.reactor = Reactor(localRepository: localRepository) }
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupConstraints()
        self.setupSearchController()
    }
}

private extension SearchViewController {
    // MARK: - setupUI
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    // MARK: - View Layout
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupSearchController() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
}

// MARK: - Bind
extension SearchViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        bindSearch(reactor: reactor)
        bindTableView(reactor: reactor)
    }
}
