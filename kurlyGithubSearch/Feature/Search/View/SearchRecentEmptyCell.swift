//
//  SearchRecentEmptyCell.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/23/26.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SearchRecentEmptyCell: BaseTableViewCell {
    
    //MARK: - UI
    private let messageLabel = UILabel().then {
        $0.text = "최근 검색 기록이 없습니다."
        $0.textAlignment = .center
        $0.textColor = .systemGray
        $0.font = .systemFont(ofSize: 16)
    }
    
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraints()
    }
}

extension SearchRecentEmptyCell {
    func setupUI() {
        contentView.addSubview(messageLabel)
    }
    
    func setupConstraints() {
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}


