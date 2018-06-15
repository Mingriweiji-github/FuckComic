//
//  UWebViewController.swift
//  FuckComic
//
//  Created by Roc01 on 2018/6/15.
//  Copyright © 2018年 Roc.iMac01. All rights reserved.
//

import UIKit
import WebKit

class UWebViewController: BaseViewController {
    var request: URLRequest!
    
    lazy var webView: WKWebView = {
        let wk = WKWebView()
        wk.allowsBackForwardNavigationGestures = true
        wk.uiDelegate = self as? WKUIDelegate
        wk.navigationDelegate = self as? WKNavigationDelegate
        return wk
    }()
    
    lazy var progressView: UIProgressView = {
        let pw = UIProgressView()
        pw.trackImage = UIImage(named: "nav_bg")
        pw.progressTintColor = UIColor.white
        return pw
    }()
    
    convenience init(url: String?) {
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(request)
    }
    override func configUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges)}
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints{
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(12)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_reload"), style: .plain, target: self, action: #selector(reload))
    }
    
    @objc func reload() {
        webView.reload()
    }
    override func pressBack() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}
