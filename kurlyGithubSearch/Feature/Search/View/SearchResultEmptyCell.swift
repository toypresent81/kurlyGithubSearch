//
//  SearchEmptyCell.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/23/26.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class SearchResultEmptyCell: BaseTableViewCell {
    
    //MARK: - UI
    private let messageLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
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

extension SearchResultEmptyCell {
    func setupUI() {
        contentView.addSubview(messageLabel)
    }
    
    func setupConstraints() {
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
