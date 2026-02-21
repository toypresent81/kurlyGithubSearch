//
//  SplashViewController.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import SnapKit
import Then
import ReactorKit
import RxCocoa

final class SplashViewController: UIViewController {
        
    typealias Reactor = SplashViewReactor
    var disposeBag = DisposeBag()
    
    // MARK: - UI
    private let appNameLabel = UILabel().then {
        $0.text = "KurlyGithubSearch"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.textAlignment = .center
    }

    private let authorLabel = UILabel().then {
        $0.text = "정 진식"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textAlignment = .right
        $0.textColor = .systemGray
    }
    
    // MARK: - Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        defer { self.reactor = Reactor() }
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.setupConstraints()
    }
}

private extension SplashViewController {
    // MARK: - setupUI
    func setupUI() {
        view.addSubview(appNameLabel)
        view.addSubview(authorLabel)
    }
    
    // MARK: - View Layout
    func setupConstraints() {
        appNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        authorLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Bind
extension SplashViewController: ReactorKit.View {
    func bind(reactor: Reactor) {
        // MARK: - Action
        reactor.action.onNext(.startAnimation)
                
        // MARK: - State
        reactor.state.map { $0.appNameAlpha }
            .distinctUntilChanged()
            .bind(to: appNameLabel.rx.alpha)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.appNameAlpha }
            .filter { $0 == 1 }
            .delay(.milliseconds(2500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let searchViewController = SearchViewController()                
                let navigationController = UINavigationController(rootViewController: searchViewController)
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.modalTransitionStyle = .crossDissolve
                self.present(navigationController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
