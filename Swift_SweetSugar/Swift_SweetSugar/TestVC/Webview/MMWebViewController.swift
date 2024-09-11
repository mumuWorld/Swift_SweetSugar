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
import Photos

class MMWebViewController: UIViewController {

    lazy var webview: WKWebView = {
        //这样能确保复制到cookie
        let script = WKUserScript(source: "document.cookie = 'test=1'", injectionTime: .atDocumentStart, forMainFrameOnly: false)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(script)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let item = WKWebView(frame: .zero, configuration: configuration)
        item.uiDelegate = self
        item.navigationDelegate = self
        item.backgroundColor = .lightGray
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
    
    private var scrollViewOffsetObserver: NSKeyValueObservation?
    private var scrollViewCotnentSizeObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(webview)
        view.addSubview(panGestureView)
//        view.insertSubview(panGestureView, belowSubview: webview)
//        panGestureView.addSubview(webview)
//        webview.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(100)
//            make.bottom.equalToSuperview().offset(-200)
//            make.leading.trailing.equalToSuperview()
//        }
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGes(sender:)))
//        pan.delegate = self
//        webview.scrollView.addGestureRecognizer(pan)
        panGestureView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
            
//        url = "https://shared.youdao.com/dict/market/shop-window-test/#/?category=12&componentId=1&uid=urs-phoneyd.d978037eb3c0483d9%40163.com&promoteImageUrl=https://img14.360buyimg.com/pop/jfs/t1/195403/21/29656/185966/6363360aE604053f0/fa4132d1d68f2613.jpg&itemName=%E7%BD%91%E6%98%93%E4%B8%A5%E9%80%89%20%E6%97%A0%E7%BA%BF%E6%8C%89%E6%91%A9%E5%99%A8%20%E9%A2%88%E6%A4%8E%E6%8C%89%E6%91%A9%E5%99%A8%E6%8C%89%E6%91%A9%E5%9E%AB%E9%9D%A0%E6%9E%95%E8%85%B0%E9%83%A8%E8%83%8C%E9%83%A8%E6%8C%89%E6%91%A9%E5%99%A8%20%E5%85%A8%E8%BA%AB%E6%8C%89%E6%91%A9%E4%BB%AA%20%E5%86%B0%E5%B2%9B%E8%93%9D%E7%94%9F%E6%97%A5%E7%A4%BC%E7%89%A9%E8%8A%82%E6%97%A5%E9%80%81%E7%A4%BC%E9%80%81%E6%9C%8B%E5%8F%8B%E9%80%81%E7%88%B6%E6%AF%8D&itemPrice=29900&strikeThroughPrice=30000&buttonText=%E8%B4%AD%E4%B9%B0&nickname=%E5%88%9B%E4%BD%9C%E8%80%85%E5%90%8D%E7%A7%B0&avatar=https://ydlunacommon-cdn.nosdn.127.net/91aa66226b7f4567c7db9d321ab2503b.png&landingPageUrl=https://union-click.jd.com/jdc?e=&p=JF8BAO0JK1olXwYFUVlVAUsXA18BG1kRXwYAZBoCUBVIMzZNXhpXVhgcDBsJVFRMVnBaRQcLVAYAUFxdClRORjNVK1pAIn5pLBpbaFFPWwhhHRtvHBxWNwhRBHsSA24JElIRXwcHZF5cCUkVB2cKGVMlbQYHZBwz3se31MaqzPOehbeTg_rc3tqn2tmTwvqBiIyQg-X5OEkWAmsJGVIWXQUyVFlaC0oUCm8AHl4WWTYCXFptUx55BmldHw8TDgEDXFlVAHsnM2w4K2sVbQUyCjBcW0wSC24BEzVIW15ECg4PUyUUBGYLG10SbQQDVVxfOHs&hide-toolbar=true"
        url = "https://www.baidu.com"
//        loadLocal()
//        webview.scrollView.panGestureRecognizer.cancelsTouchesInView = false
//        webview.scrollView.panGestureRecognizer.delaysTouchesEnded = false
//        webview.scrollView.panGestureRecognizer.require(toFail: pan)
//        panGestureView.gestureRecognizers?.forEach({ $0.cancelsTouchesInView = false })
//        view.addSubview(panGestureView)
            
        scrollViewOffsetObserver = webview.scrollView.observe(\.contentOffset, options: [.new], changeHandler: { [weak self] scrollView, change in
            guard let newOffset = change.newValue else { return }
            // 在这里处理scrollView的contentOffset的变化
//            mm_printLog("offset->\(newOffset)")
        })
        
        scrollViewCotnentSizeObserver = webview.scrollView.observe(\.contentSize, options: [.new, .old], changeHandler: { [weak self] scrollView, change in
            guard let newOffset = change.newValue, let old = change.oldValue else { return }
            // 在这里处理scrollView的contentOffset的变化
            mm_printLog("size->\(newOffset),\(old)")
        })
        
        
    }
    
    
    func loadLocal() {
//        let path = Bundle.main.path(forResource: "html/14.Some unexpected hidden locations for cameras", ofType: "html")
//        let path = Bundle.main.path(forResource: "百度一下，你就知道", ofType: "html")
//        let path = Bundle.main.path(forResource: "sw", ofType: "")?.appendPathComponent(string: "index.html")
//        let url = URL(string: "https://shared.youdao.com/dict/market/shop-window-test/#/more?from=searchIcon&hide-toolbar=true&full-screen=true")
//        let urlStr_7 = "https://www.baidu.com/s?ie=UTF-8&wd="
//        let urlStr_7 = "https://h5.youdao.com/preview/1025?_t=1681289492028&title="
//        var url = urlStr_7 + ".urlEncoded()
//        let url = "https://www.baidu.com/s?ie=UTF-8&wd="
        let url = "https://github.com/SwiftOldDriver/iOS-Weekly/releases.atom"
        let content = """
        一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三
"""
        let title = "测试时代大厦"
//        let url = "https://www.jianshu.com/p/3acc4fbf84a6"
//        let url = "https://h5.youdao.com/preview/1025?_t=1681819816789&title=\(title)&content=\(content)&autoScale=true".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url_7 = URL(string: url)
        mm_printLog("test->2, \(url.count)")
//        url?.pathExtension
        //资源放在第三方库总
//        let path = LocalWebPath().getPath()
//        let tUrl = URL(fileURLWithPath: path)
        let request = URLRequest(url: url_7!)
        webview.load(request)
    }
    
    
    deinit {
        mm_printLog("MMWebViewController deinit")
        scrollViewOffsetObserver?.invalidate()
        scrollViewCotnentSizeObserver?.invalidate()
    }
    
    @IBAction func snapshot(_ sender: Any) {
//        saveImg()
        //wkwebview 官方截图
//        sysSnapshot()
//        scrollHeight()
//        takeSnapshotOfWKWebView()
//        testPDF()
        test2()
    }
    
    @IBAction func handleCookie(_ sender: Any) {
        //真的能获取到cookie
//        "BDORZ=AE84CDB3A529C0F8A2B9DCDD1D18B695; SE_LAUNCH=5%3A28059007; ZFY=2FlPTFGKyJR:A68lPI:B48KtaeiF3L99qV5fQ8HThNiAE:C; BDSVRBFE=Go; Hm_lpvt_12423ecbc0e2ca965d84259063d35238=1683540426; Hm_lvt_12423ecbc0e2ca965d84259063d35238=1682217685,1683540426; __bsi=10868730033506942869_00_27_N_R_4_0303_c02f_Y; plus_cv=1::m:f3ed604d; plus_lsv=3965f6be7add0277; cookietest=1; BA_HECTOR=85i58l0ha58g8424ak80ah181i5hiea1m; test=1; PSINO=1; BAIDUID=849AED936BD76AB5CB37DAB7A7771E7C:FG=1"
        webview.evaluateJavaScript("document.cookie") { (result, error) in
            if let cookies = result as? String {
                mm_printLog(cookies)
            }
        }
    }
    
    var isScrolling: Bool = false
}

extension WKWebView {
    
    func takeSnapshot(longImageWidth: CGFloat, completion: @escaping (UIImage?) -> Void) {
           // 获取页面高度
        evaluateJavaScript("document.body.scrollHeight") { [weak self] result, error in
               guard let self = self, let contentHeight = result as? CGFloat else {
                   completion(nil)
                   return
               }

               // 计算截图总页数
               let pageCount = Int(ceil(contentHeight / longImageWidth))

               // 设置长图的实际高度
               let longImageHeight = contentHeight + CGFloat(pageCount - 1) * longImageWidth

               // 创建需要截取的矩形区域
               let rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: longImageHeight)
//            let rect = CGRect(x: 0, y: 0, width: self.scrollView.contentSize.width, height: self.webview.scrollView.contentSize.height)
            print("test->\(rect)")
               // 创建长图的上下文
               UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

               // 绘制长图
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
               for i in 0..<pageCount {
                   let yOffset = CGFloat(i) * longImageWidth
                   self.scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
                   self.drawHierarchy(in: CGRect(x: 0, y: yOffset, width: rect.width, height: longImageWidth), afterScreenUpdates: true)
               }

               let image = UIGraphicsGetImageFromCurrentImageContext()

               // 结束绘制
               UIGraphicsEndImageContext()

               completion(image)
           }
       }

}
extension MMWebViewController {
    /// 完全可用， 会有滚动动画: 利用滚动截图
    func test2() {
        webview.snapshot2 { [weak self] image in
            // 处理image
            self?.saveImg(img: image)
        }
    }
    
    /// 可用，但是目前高度不一致。会留有空白部分
    func testPDF() {
        webview.takeScreenshotOfFullContent { [weak self] (image) in
            // 处理image
            self?.saveImg(img: image)
        }
    }
    
    //https://juejin.cn/post/6844903680055967757
    private func takeSnapshotOfWKWebView() {
        self.webview.scrollView.takeScreenshotOfFullContent { [weak self] (image) in
            // 处理image
            self?.saveImg(img: image)
        }
    }
    func scrollHeight() {
        webview.takeSnapshot(longImageWidth: webview.mm_height) { [weak self] img in
            self?.saveImg(img: img)
        }
    }
}
extension MMWebViewController {
    func saveImg(img: UIImage?) {
        guard let img else { return }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: img)
        }) { (isSuccess, error) in
            DispatchQueue.main.async {
                if let error {
                    mm_printLog(error)
//                                Toast.init(text: "保存图片失败").show()
                } else {
                    mm_printLog("保存图片成功")
                }
            }
        }
    }
    func sysSnapshot() {
        let configure = WKSnapshotConfiguration()
        configure.rect = CGRect(x: 0, y: 0, width: self.webview.scrollView.contentSize.width, height: self.webview.scrollView.contentSize.height)
        print("test->\(configure.rect)")
        webview.takeSnapshot(with: configure) { [weak self] img, error in
            if let error {
                print("test->\(error)")
            }
            self?.saveImg(img: img)
        }
    }
}
extension MMWebViewController {
    func saveImg() {
        captureWebView { image in
            if let shareImage = image {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: shareImage)
                }) { (isSuccess, error) in
                    DispatchQueue.main.async {
                        if let error {
                            mm_printLog(error)
    //                                Toast.init(text: "保存图片失败").show()
                        } else {
                            mm_printLog("保存图片成功")
                        }
                    }
                }
            }
        }
    }
    
    func captureWebView(completion: @escaping (UIImage?) -> Void) {
        //解决wkWebview截图是黑色问题
        self.startCaptureWebview { [weak self] _ in
            guard let self = self else {return}
            self.startCaptureWebview(completion: { (image) in
                completion(image)
            })
        }
    }
    
    func startCaptureWebview(completion: @escaping (UIImage?) -> Void) {
        webview.scrollView.setContentOffset(CGPoint.zero, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let rect = CGRect(x: 0, y: 0, width: self.webview.scrollView.contentSize.width, height: self.webview.scrollView.contentSize.height)
            print("test->\(rect)")
            //保证分享的图片是750 * 1334
            UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.main.scale)
            self.webview.drawHierarchy(in: rect, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completion(image)
        }
    }
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        mm_printLog("test->加载policy")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mm_printLog("test->加载完成")
//        let jsUrl = URL(string: "https://c.youdao.com/fanyiguan/webTrans/index.js")
//        let str = try? String(contentsOf: jsUrl!, encoding: .utf8)
//        webView.evaluateJavaScript(str!, completionHandler: nil)
//        webView.evaluateJavaScript("document.documentElement.outerHTML") { str, error in
//            mm_printLog("html->\(self.webview)")
//        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        mm_printLog("test->加载失败")
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
//extension WKWebView {
//    func screenCapture() -> UIImage {
//        var capturedView : UIView? = self.snapshotView(afterScreenUpdates: false)
//        var image : UIImage? = nil;
//
//        if (capturedView != nil) {
//            let size = self.scrollView.contentSize;
//            UIGraphicsBeginImageContextWithOptions(size, true, 0);
//            let rect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, size.width, size.height)
//            capturedView?.drawHierarchy(in: rect, afterScreenUpdates: true);
//            image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//        }
//        return image!;
//    }
//
//    func screenCapture(size: CGSize) -> UIImage? {
//        var capturedView : UIView? = self.snapshotView(afterScreenUpdates: false)
//        var image : UIImage? = nil;
//
//        if (capturedView != nil) {
//            UIGraphicsBeginImageContextWithOptions(size, true, 0);
//            guard let ctx = UIGraphicsGetCurrentContext() else { return nil };
//            let scale : CGFloat! = size.width / capturedView!.layer.bounds.size.width;
//            let transform = CGAffineTransformMakeScale(scale, scale);
//            ctx.concatenate(transform);
//            capturedView?.drawHierarchy(in: self.bounds, afterScreenUpdates: true);
//            image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//        }
//        return image;
//    }
//}
