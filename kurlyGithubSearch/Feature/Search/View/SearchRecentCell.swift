//
//  SearchRecentCell.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SearchRecentCell: BaseTableViewCell {
    
    //MARK: - UI
    private let titleLabel = UILabel().then { // 타이틀
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .darkGray
    }
    private let dateLabel = UILabel().then { // 날짜
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .gray
    }
    private let deleteButton = UIButton(type: .custom).then { // 삭제버튼
        $0.setImage(UIImage(named: "delete_button"), for: .normal)
    }
    
    var deleteAction: (() -> Void)?
    
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraints()
        self.setupObservble()
    }
    
    func configure(with entity: RecentSearchEntity, isSearching: Bool) {
        titleLabel.text = entity.keyword
        
        if let date = entity.searchedAt {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd."
            dateLabel.text = formatter.string(from: date)
        }
        
        if isSearching { // 검색 중
            dateLabel.isHidden = false
            deleteButton.isHidden = true
        } else {
            dateLabel.isHidden = true
            deleteButton.isHidden = false
        }
    }
}

extension SearchRecentCell {
    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupObservble() {
        self.deleteButton.rx.tap // 개별 삭제버튼 이벤트
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.deleteAction?()
            })
            .disposed(by: self.disposeBag)
    }
}
