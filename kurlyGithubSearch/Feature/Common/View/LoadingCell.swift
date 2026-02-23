//
//  LoadingCell.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/21/26.
//

import UIKit
import SnapKit

final class LoadingCell: BaseTableViewCell {

    // MARK: - UI
    private let indicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indicator.startAnimating()
    }
    
    func configure() {
        indicator.startAnimating()
    }
}

extension LoadingCell {
    func setupUI() {
        contentView.addSubview(indicator)
    }
    
    func setupConstraints() {
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
