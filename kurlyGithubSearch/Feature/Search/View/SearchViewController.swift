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
        $0.register(Reusable.searchResultCell)
        $0.register(Reusable.loadingCell)
        $0.register(Reusable.emptyCell)
    }
    struct Reusable {
        static let searchRecentCell = ReusableCell<SearchRecentCell>()
        static let searchResultCell = ReusableCell<SearchResultCell>()
        static let loadingCell = ReusableCell<LoadingCell>()
        static let emptyCell = ReusableCell<SearchEmptyCell>()
    }

    lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchBar.placeholder = "저장소 검색"
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.tintColor = .systemPurple
    }
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
        $0.color = .systemPurple
    }
        
    // MARK: Rx
    var disposeBag = DisposeBag()

    // MARK: - Initializing
    init() {
        let localRepository = SearchLocalRepository()
        let networkManager = NetworkManager()
        let searchService = SearchService(networkManager: networkManager)
        
        defer { self.reactor = Reactor(localRepository: localRepository, searchService: searchService) }
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
        self.configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        // iOS 26 대응: transparent background
        let appearance = UINavigationBarAppearance()
        if #available(iOS 26.0, *) {
            appearance.configureWithTransparentBackground() // Large Title 안보이는 이슈 수정
        } else {
            // iOS 26이사 투명 배경이면 search bar 뒤쪽이 보여서 opaque 사용
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
        }
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]

        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
}

private extension SearchViewController {
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(indicator)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        indicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(60)
        }
    }
    
    private func setupSearchController() {
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        let textField = searchController.searchBar.searchTextField
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
    }
}

// MARK: - Bind
extension SearchViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        reactor.state
            .map { state in
                state.isLoading && state.repositories.isEmpty
            }
            .distinctUntilChanged()
            .bind(to: indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        bindSearch(reactor: reactor)
        bindTableView(reactor: reactor)
        
        

    }
}
