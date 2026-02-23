//
//  SearchRecentFooterView.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SearchRecentFooterView: BaseView {
    
    //MARK: - UI
    private let deleteAllButton = UIButton(type: .system).then { // 전체삭제
        $0.setTitle("전체삭제", for: .normal)
        $0.setTitleColor(.systemRed, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
    }
    let underlineView = UIView().then {
        $0.backgroundColor = .systemGray4
    }
    
    var deleteAllAction: (() -> Void)?
    
    // MARK: - Initializing
    init() {
        super.init(frame: .zero)
        self.setupUI()
        self.setupConstraints()
        self.setupObservble()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchRecentFooterView {
    func setupUI() {
        addSubview(deleteAllButton)
        addSubview(underlineView)
    }
    
    func setupConstraints() {
        deleteAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
        underlineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupObservble() {
        self.deleteAllButton.rx.tap // 전체삭제 버튼 이벤트
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.deleteAllAction?()
            })
            .disposed(by: self.disposeBag)
    }
}
