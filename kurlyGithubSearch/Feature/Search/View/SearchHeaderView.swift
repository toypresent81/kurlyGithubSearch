//
//  SearchHeaderView.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import SnapKit
import Then

final class SearchHeaderView: BaseView {
    
    enum Style {
        case recent
        case result
    }
    
    //MARK: - UI
    private let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 14)
    }
    
    // MARK: - Initializing
    init() {
        super.init(frame: .zero)
        self.setupUI()
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, style: Style) {
        titleLabel.text = title
        
        switch style {
        case .recent:
            titleLabel.textColor = .label
        case .result:
            titleLabel.textColor = .systemGray
        }
    }
}

extension SearchHeaderView {
    func setupUI() {
        self.backgroundColor = .white
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
