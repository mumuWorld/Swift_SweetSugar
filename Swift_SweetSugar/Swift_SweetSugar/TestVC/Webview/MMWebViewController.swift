//
//  MMWebViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/5/28.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import WebKit

class MMWebViewController: UIViewController {

    lazy var webview: WKWebView = {
        let configure = WKWebViewConfiguration()
        let userContent = WKUserContentController()
        let item = WKWebView()
        item.uiDelegate = self
        item.navigationDelegate = self
        return item
    }()
    
    
    var url: String = "" {
        didSet {
            guard let tUrl = URL(string: url) else { return }
            let request = URLRequest(url: tUrl)

            webview.load(request)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        url = "https://mr.baidu.com/r/naQBhqv9W8?f=cp&u=7d85acc17a4065ed"
        url = "http://www.globaltimes.cn"
    }
}

extension MMWebViewController: WKUIDelegate {
    
}

extension MMWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mm_printLog("加载完成")
        let jsUrl = URL(string: "https://c.youdao.com/fanyiguan/webTrans/index.js")
        let str = try? String(contentsOf: jsUrl!, encoding: .utf8)
        webView.evaluateJavaScript(str!, completionHandler: nil)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        mm_printLog("加载失败")
    }
}
