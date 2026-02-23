//
//  WebViewController.swift
//  kurlyGithubSearch
//
//  Created by toypresent on 2/21/26.
//

import WebKit
import SnapKit

final class WebViewController: UIViewController {
            
    // MARK: - UI
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        return WKWebView(frame: .zero, configuration: config)
    }()
    
    // MARK: - Properties
    private let urlString: String
    
    // MARK: - Initializing
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.setupConstraints()
        self.loadWebPage()
    }
    
    func loadWebPage() {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

private extension WebViewController {
    // MARK: - setupUI
    func setupUI() {
        view.addSubview(webView)
    }
    
    // MARK: - View Layout
    func setupConstraints() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
