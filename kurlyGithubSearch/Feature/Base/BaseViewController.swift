//
//  BaseViewController.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/20/26.
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
//        
//        backgroundImageColor: UIColor? = UIColor.white,
//        prefersHidden: Bool? = nil,
//        isTranslucent: Bool? = nil,
//        automaticallyAdjustsLeftBarButtonItem: Bool = true,
//        backgroundViewColor: UIColor = UIColor.white
//    ) {
//        self.backgroundColor = backgroundViewColor
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
//        self.navigationController?.setNavigationBarHidden(self.navigationBarData.prefersHidden, animated: true)
//        self.navigationController?.hideHairline()
//        self.setNavigationBar(
//            isTranslucent: self.navigationBarData.isTranslucent,
//            backgroundImageColor: self.navigationBarData.barBackgroundImageColor
//        )
//    }
//    
//    override func updateViewConstraints() {
//        if !self.didSetupConstraints {
//            self.setupConstraints()
//            self.didSetupConstraints = true
//        }
//        super.updateViewConstraints()
//    }
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        // Trait collection has already changed
//        self.setNavigationBar(
//            isTranslucent: self.navigationBarData.isTranslucent,
//            backgroundImageColor: self.navigationBarData.barBackgroundImageColor
//        )
//        self.setNeedsStatusBarAppearanceUpdate()
//    }
//    
//    func setupConstraints() {
//        // Override point
//    }
//    
//    
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
//
//extension BaseViewController {
//    // MARK: cancelButtonDidTap
//    @objc func cancelButtonDidTap() {
//        self.dismiss(animated: true, completion: {
//            NotificationCenter.default.post(name: Notification.createName(.closeModal), object: nil)
//        })
//    }
//    
//    @objc func backAction() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    // MARK: addDismissKeyboardGesture
//    func addDismissKeyboardGesture(){
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endEditing)))
//    }
//    
//    // MARK: Adjusting Navigation Item
//    func adjustLeftBarButtonItem() {
//        let tintColor: UIColor = ColorPaletteV2.button.color(index: .backgroundActive)
//        if self.navigationController?.viewControllers.count ?? 0 > 1 { // pushed
//            let backButton = UIButton.drawNavigationLeftButton(
//                image: Asset.Images.Back.icBack.image,
//                target: self,
//                selector: #selector(backAction),
//                tintColor:  tintColor
//            )
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//
//        } else if self.presentingViewController != nil { // presented
//            
//            dismissButton = UIButton.drawNavigationLeftButton(
//                image: Asset.Images.icClose.image,
//                target: self,
//                selector: #selector(cancelButtonDidTap),
//                tintColor:  tintColor
//            )
//            
//            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
//        }
//    }
//    
//    func freeze() {
//        self.view.isUserInteractionEnabled = false
//        self.navigationController?.navigationBar.isUserInteractionEnabled = false
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//    }
//    
//    func unfreeze() {
//        self.view.isUserInteractionEnabled = true
//        self.navigationController?.navigationBar.isUserInteractionEnabled = true
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//    }
//}
//
