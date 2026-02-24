//
//  SearchResultCell.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/21/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import Kingfisher

final class SearchResultCell: BaseTableViewCell {
    
    //MARK: - UI
    private let thumbnailImageView = UIImageView().then { // 썸네일 이미지
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 22
    }
    
    private let nameLabel = UILabel().then { // 이름
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .label
        $0.numberOfLines = 1
    }
    
    private let descriptionLabel = UILabel().then { // desc
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .systemGray
        $0.numberOfLines = 1
    }
    
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        self.setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
    }
    
    func configure(with repository: Repository) {
        nameLabel.text = repository.name
        descriptionLabel.text = repository.owner.login
        
        if let url = URL(string: repository.owner.avatarURL) {
            thumbnailImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "folder.fill"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        } else {
            thumbnailImageView.image = UIImage(systemName: "folder.fill")
        }
    }
}

extension SearchResultCell {
    func setupUI() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
