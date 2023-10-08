//
//  UITestVC+WKWebView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/7/19.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation
import WebKit

extension UITestVC: WKNavigationDelegate {
    
}


extension UITestVC: WKUIDelegate {
    
    func addWebView() {
        print("test-> isViewLoaded3: \(isViewLoaded)")
        view.addSubview(panGestureView)
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(200)
        }
        panGestureView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(200)
        }
//        webView.scrollView.panGestureRecognizer.cancelsTouchesInView = false
        webView.load(URLRequest(url: URL(string: "http://baidu.com")!))
        
        webView.scrollView.addGestureRecognizer(panGesture)
//        @MainActor public class func animate(springDuration duration: TimeInterval = 0.5, bounce: CGFloat = 0.0, initialSpringVelocity: CGFloat = 0.0, delay: TimeInterval = 0.0, options: UIView.AnimationOptions = [], animations: () -> Void, completion: ((Bool) -> Void)? = nil)
//        UIView.animate(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, usingSpringWithDamping: <#T##CGFloat#>, initialSpringVelocity: <#T##CGFloat#>, animations: <#T##() -> Void#>)
    }
}
