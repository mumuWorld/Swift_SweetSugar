//
//  MMWebViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/5/28.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import WebKit
import testDev

class MMWebViewController: UIViewController {

    lazy var webview: WKWebView = {
        let configure = WKWebViewConfiguration()
        let userContent = WKUserContentController()
//        userContent.add(self, name: "translate")
        configure.userContentController = userContent
        let item = WKWebView(frame: .zero, configuration: configure)
        item.uiDelegate = self
        item.navigationDelegate = self
//        item.observe(\.themeColor) { item, _ in
//
//        }
//        item.configuration.preferences.isTextInteractionEnabled
        return item
    }()
    
    
    var url: String = "" {
        didSet {
            guard let tUrl = URL(string: url) else { return }
            let request = URLRequest(url: tUrl)

            webview.load(request)
        }
    }
    
    lazy var panGestureView: UIView = {
        let item = MMTouchsView()
        item.backgroundColor = UIColor.green
        item.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGes(sender:)))
        pan.delegate = self
        pan.cancelsTouchesInView = false
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        webview.scrollView.panGestureRecognizer.require(toFail: pan)
//        item.addGestureRecognizer(pan)
//        item.addGestureRecognizer(tap)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
//        view.addSubview(panGestureView)
//        view.insertSubview(panGestureView, belowSubview: webview)
//        panGestureView.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGes(sender:)))
        pan.delegate = self
        webview.scrollView.addGestureRecognizer(pan)
//        panGestureView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
            
        url = "https://shared.youdao.com/dict/market/shop-window-test/#/?category=12&componentId=1&uid=urs-phoneyd.d978037eb3c0483d9%40163.com&promoteImageUrl=https://img14.360buyimg.com/pop/jfs/t1/195403/21/29656/185966/6363360aE604053f0/fa4132d1d68f2613.jpg&itemName=%E7%BD%91%E6%98%93%E4%B8%A5%E9%80%89%20%E6%97%A0%E7%BA%BF%E6%8C%89%E6%91%A9%E5%99%A8%20%E9%A2%88%E6%A4%8E%E6%8C%89%E6%91%A9%E5%99%A8%E6%8C%89%E6%91%A9%E5%9E%AB%E9%9D%A0%E6%9E%95%E8%85%B0%E9%83%A8%E8%83%8C%E9%83%A8%E6%8C%89%E6%91%A9%E5%99%A8%20%E5%85%A8%E8%BA%AB%E6%8C%89%E6%91%A9%E4%BB%AA%20%E5%86%B0%E5%B2%9B%E8%93%9D%E7%94%9F%E6%97%A5%E7%A4%BC%E7%89%A9%E8%8A%82%E6%97%A5%E9%80%81%E7%A4%BC%E9%80%81%E6%9C%8B%E5%8F%8B%E9%80%81%E7%88%B6%E6%AF%8D&itemPrice=29900&strikeThroughPrice=30000&buttonText=%E8%B4%AD%E4%B9%B0&nickname=%E5%88%9B%E4%BD%9C%E8%80%85%E5%90%8D%E7%A7%B0&avatar=https://ydlunacommon-cdn.nosdn.127.net/91aa66226b7f4567c7db9d321ab2503b.png&landingPageUrl=https://union-click.jd.com/jdc?e=&p=JF8BAO0JK1olXwYFUVlVAUsXA18BG1kRXwYAZBoCUBVIMzZNXhpXVhgcDBsJVFRMVnBaRQcLVAYAUFxdClRORjNVK1pAIn5pLBpbaFFPWwhhHRtvHBxWNwhRBHsSA24JElIRXwcHZF5cCUkVB2cKGVMlbQYHZBwz3se31MaqzPOehbeTg_rc3tqn2tmTwvqBiIyQg-X5OEkWAmsJGVIWXQUyVFlaC0oUCm8AHl4WWTYCXFptUx55BmldHw8TDgEDXFlVAHsnM2w4K2sVbQUyCjBcW0wSC24BEzVIW15ECg4PUyUUBGYLG10SbQQDVVxfOHs&hide-toolbar=true"
//        url = "http://www.globaltimes.cn"
        loadLocal()
//        webview.scrollView.panGestureRecognizer.cancelsTouchesInView = false
//        webview.scrollView.panGestureRecognizer.delaysTouchesEnded = false
//        webview.scrollView.panGestureRecognizer.require(toFail: pan)
//        panGestureView.gestureRecognizers?.forEach({ $0.cancelsTouchesInView = false })
//        view.addSubview(panGestureView)

        
    }
    
    
    
    func loadLocal() {
//        let path = Bundle.main.path(forResource: "html/14.Some unexpected hidden locations for cameras", ofType: "html")
//        let path = Bundle.main.path(forResource: "百度一下，你就知道", ofType: "html")
//        let path = Bundle.main.path(forResource: "sw", ofType: "")?.appendPathComponent(string: "index.html")
        let url = URL(string: "https://shared.youdao.com/dict/market/shop-window-test/#/more?from=searchIcon&hide-toolbar=true&full-screen=true")
//        url?.pathExtension
        //资源放在第三方库总
        let path = LocalWebPath().getPath()
        let tUrl = URL(fileURLWithPath: path)
        let request = URLRequest(url: tUrl)
        webview.load(request)
    }
    
    
    deinit {
        mm_printLog("MMWebViewController deinit")
    }
    
    var isScrolling: Bool = false
}

extension MMWebViewController {
    @objc func handlePanGes(sender: UIPanGestureRecognizer) {
        mm_printLog("PanGes->\(sender)")
    }
}

extension MMWebViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        mm_printLog("PanGes2->\(otherGestureRecognizer)")
        if otherGestureRecognizer is UITapGestureRecognizer {
            mm_printLog("PanGes4->\(otherGestureRecognizer)")
            isScrolling = false
            return false
        }
        isScrolling = true
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        mm_printLog("PanGes3->\(otherGestureRecognizer)")
        if otherGestureRecognizer is UITapGestureRecognizer {
            return true
        }
        return false
    }
}

extension MMWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        mm_printLog("message->\(message)")
    }
    
}

extension MMWebViewController: WKUIDelegate {
    
}

extension MMWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mm_printLog("加载完成")
        let jsUrl = URL(string: "https://c.youdao.com/fanyiguan/webTrans/index.js")
//        let str = try? String(contentsOf: jsUrl!, encoding: .utf8)
//        webView.evaluateJavaScript(str!, completionHandler: nil)
//        webView.evaluateJavaScript("document.documentElement.outerHTML") { str, error in
//            mm_printLog("html->\(self.webview)")
//        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        mm_printLog("加载失败")
    }
}

class MMTouchsView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        mm_printLog("view->\(view)")
        return view
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog("touch")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog("Moved")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog("Ended")
    }
}
