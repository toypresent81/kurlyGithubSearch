//
//  SearchRecentHeaderView.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import SnapKit
import Then

final class SearchRecentHeaderView: BaseView {
    
    //MARK: - UI
    private let titleLabel = UILabel().then {
        $0.text = "최근 검색"
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
}

extension SearchRecentHeaderView {
    func setupUI() {
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
