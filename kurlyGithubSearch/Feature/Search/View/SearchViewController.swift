//
//  SearchViewController.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import SnapKit
import Then

final class SearchViewController: UIViewController {
        
    private let titleLabel = UILabel().then {
        $0.text = "Search"
        $0.font = .systemFont(ofSize: 28, weight: .bold)
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
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.setupConstraints()
    }
}

private extension SearchViewController {
    // MARK: - setupUI
    func setupUI() {
        view.backgroundColor = .white
                
        view.addSubview(titleLabel)
    }
    
    // MARK: - View Layout
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(20)
        }        
    }
}
