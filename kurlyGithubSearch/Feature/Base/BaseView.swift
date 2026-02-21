//
//  BaseView.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/21/26.
//

import UIKit
import RxSwift
import RxCocoa

class BaseView: UIView {
    
    // MARK: Properties
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    // MARK: Rx
    var disposeBag = DisposeBag()
        
    // MARK: - Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
    }
}
