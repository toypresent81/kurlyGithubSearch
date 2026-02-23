////
////  BaseViewController.swift
////  kurlyGithubSearch
////
////  Created by toypresent on 2/20/26.
////
//
//import UIKit
//import RxSwift
//
//class BaseViewController: UIViewController {
//    
//    // MARK: Properties
//    lazy private(set) var className: String = {
//        return type(of: self).description().components(separatedBy: ".").last ?? ""
//    }()
//    
//    private var backgroundColor: UIColor
//        
//    // MARK: Initializing
//    init(
//    ) {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required convenience init?(coder aDecoder: NSCoder) {
//        self.init()
//    }
//    
//    deinit {
//    }
//    
//    // MARK: Rx
//    var disposeBag = DisposeBag()
//    
//    
//    // MARK: Layout Constraints
//    private(set) var didSetupConstraints = false
//    
//    
//    // MARK: View Lifecycle
//    override func viewDidLoad() {
//        self.view.setNeedsUpdateConstraints()
//        self.view.backgroundColor = self.backgroundColor
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//}
//
//extension BaseViewController {
//    func loadingAnimationViewAddSubView() {
//        self.view.addSubview(self.loadingAnimationView)
//    }
//
//    func loadingAnimationViewConstraints(inset: CGFloat = 0) {
//        self.loadingAnimationView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            if inset > 0 {
//                make.centerY.equalTo(UIScreen.main.bounds.midY - inset)
//            } else {
//                make.centerY.equalTo(UIScreen.main.bounds.midY)
//            }
//            make.size.equalTo(70)
//        }
//    }
//}
