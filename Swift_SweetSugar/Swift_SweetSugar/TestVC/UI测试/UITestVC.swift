//
//  UITestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import YYText
import SnapKit
import AVKit
import Lottie
import MessageUI
import WebKit
import Kingfisher

func creat(_ block:(UIButton)->()) -> UIButton {
    let btn = UIButton()
    block(btn)
    return btn
}

class UITestVC: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView_h: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    var top_h: Constraint?
    
    @IBOutlet weak var bottomView: UIView!
        
    @IBOutlet weak var gradientLayer: UIImageView!
    
    @IBOutlet weak var widthLabel: UILabel!
    
    @IBOutlet weak var pieChartView: MMPieChartView!
    
    @IBOutlet weak var changeImageSizeBtn: UIButton!
    
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var testButton_width: NSLayoutConstraint!
    
    var newWindow: UIWindow?
    
    lazy var customButton: YDCustomButton = {
        let item = YDCustomButton()
        item.backgroundColor = .brown
        item.layer.cornerRadius = 15
        return item
    }()
    
    var emitter: CAEmitterLayer?
    
    let bar: UIButton = creat { (btn) in
        mm_printLog("测试调用")
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(handleClick(sender:)), for: .touchUpInside)
    }
    
    var attrText: YYLabel = {
        let label = YYLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .blue
        return label
    }()
    
    lazy var avPlayer: AVPlayer = {
        let path = Bundle.main.path(forResource: "RPReplay", ofType: "MP4")
        let item = AVPlayer(playerItem: AVPlayerItem(url: URL(fileURLWithPath: path!)))
        return item
    }()
    
    lazy var avPlayerLayer: AVPlayerLayer = {
        let item = AVPlayerLayer(player: avPlayer)
        item.frame = CGRect(x: 10, y: 200, width: 200, height: 200)
        item.videoGravity = .resizeAspect
        return item
    }()
    
    @IBOutlet weak var shadowBtn: MMShadowButton!
    
    lazy var inputIconLotView: AnimationView = {
        let item = AnimationView(name: "anim_search_transform_light.json", bundle: Bundle.main)
        item.isUserInteractionEnabled = false
        item.loopMode = .loop
        return item
    }()
    
    var pictureVC: AVPictureInPictureController?
    var _compareView: UIView?
    // 高斯模糊
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 1
        return blurView
    }()
    
    lazy var panGestureView: MMPassthroughView = {
        let item = MMPassthroughView()
        item.backgroundColor = UIColor.brown.withAlphaComponent(0.5)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGes(sender:)))
//        pan.cancelsTouchesInView = false
//        pan.delegate = self
//        item.addGestureRecognizer(pan)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
//        item.addGestureRecognizer(tap)
        return item
    }()
    
    lazy var webView: WKWebView = {
        let item = WKWebView()
        item.navigationDelegate = self
        item.uiDelegate = self
        return item
    }()
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var netImageView: UIImageView!
    
    @IBOutlet weak var resetImageView: UIImageView!
    
    var customDrawView: MMHighlightView?
    
    lazy var netAniImageView: AnimatedImageView = {
        let item = AnimatedImageView()
        return item
    }()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("test-> isViewLoaded1: \(isViewLoaded)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test-> isViewLoaded2: \(isViewLoaded)")
        textView.delegate = self
//        shadowView.layer.cornerRadius = 24
      //        layer.shadowColor = UIColor(hex: 0x3C4D59, alpha: 0.9).cgColor
//        shadowView.layer.shadowColor = UIColor.black.cgColor
//        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        shadowView.layer.shadowRadius = 3
//        shadowView.layer.shadowOpacity = 1

        let baseFrame = CGRect(x: 10, y: 200, width: 200, height: 200)
//        shadowView.frame = baseFrame
//        shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]

//        let shadowSub = UIView(frame: CGRect(x: 0, y: 10, width: 50, height: 50))
//        shadowSub.backgroundColor = .red
//        shadowView.addSubview(shadowSub)
        mm_printLog("center->\(shadowView.center),position->\(shadowView.layer.position),frame->\(shadowView.frame)")
        //位置比较
        let compareView = UIView(frame: baseFrame)
        compareView.backgroundColor = .brown.withAlphaComponent(0.7)
        view.insertSubview(compareView, belowSubview: shadowView)
        compareView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(200)
            make.width.height.equalTo(200)
        }
        _compareView = compareView
        
//        shadowView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(10)
//            make.top.equalTo(_compareView!.snp.bottom).offset(20)
//            make.width.height.equalTo(200)
//        }
        
        let line: MMDottedLine = MMDottedLine()
        line.mm_size = CGSize(width: 100, height: 10)
//        line.test()
        line.mm_y = 100
        view.addSubview(line)
        
        view.addSubview(attrText)

        //也会进行放大。
//        let font = UIFont(name: "iconfont", size: 30)
//        widthLabel.font = font
//        widthLabel.text = "大 \u{e60b}"
        
        pieChartView.colors = [.brown,.brown,.green, .yellow]
        pieChartView.drawWidth = 20
        pieChartView.percents = [0.5, 0.3, 0.1, 0.1]
        pieChartView.setNeedsDisplay()
        
        var configure = customButton.configure
        configure.title = "测试文字"
        configure.titleColor = UIColor.green
        configure.selectedTitle = ""
        configure.image = UIImage(named: "btn_heart")
        configure.selectedImage = UIImage(named: "btn_heart_selected")
        customButton.setConfigure(con: configure)
        customButton.mm_size = customButton.fitSizeContent()
        customButton.origin = CGPoint(x: 100, y: 200)
        view.addSubview(customButton)
        customButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(300)
            make.size.equalTo(customButton.mm_size)
        }
        shadowBtn.layer.cornerRadius = 25
        shadowBtn.layer.masksToBounds = true

        view.addSubview(inputIconLotView)
        inputIconLotView.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-19)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(28, 28))
        }
        
        resetImageView.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalToSuperview()
        }
  
//        addWebView()
//        netImageTest()
//        createBtn()
        
//        adjustImage()
    }
    
    /// 调整图片的平铺
    func adjustImage() {
        let img = UIImage(named: "noteShowBg")!
        mm_printLog("test->\(img): size:\(img.size)")
        let middleX = ceil(img.size.width * 0.5)
        let middleY = ceil(img.size.height * 0.5)
        resetImageView.image = img.resizableImage(withCapInsets: UIEdgeInsets(top: middleY - 1, left: middleX - 1, bottom: middleY, right: middleX), resizingMode: .tile)
    }

    
    func createBtn() {
        let item = UIButton(type: .system)
        item.setTitle("确定", for: .normal)
        item.setTitleColor(UIColor.yellow, for: .normal)
        item.layer.cornerRadius = 22
        item.frame = CGRect(x: 10, y: 100, width: 100, height: 40)
        item.backgroundColor = UIColor.blue
        item.isEnabled = false
        
        let item_2 = UIButton(type: .custom)
        item_2.setTitle("确定2", for: .normal)
        item_2.setTitleColor(UIColor.yellow, for: .normal)
        item_2.setTitleColor(UIColor.yellow.withAlphaComponent(0.5), for: .disabled)
        item_2.layer.cornerRadius = 22
        item_2.layer.masksToBounds = true
        item_2.frame = CGRect(x: 10, y: 150, width: 100, height: 40)
        item_2.backgroundColor = UIColor.red
        item_2.setBackgroundImage(UIImage.createImage(.blue), for: .normal)
        item_2.isEnabled = false
        
        let item_3 = UIButton()
        item_3.setTitle("确定3", for: .normal)
        item_3.setTitleColor(UIColor.yellow, for: .normal)
        item_3.layer.cornerRadius = 22
        item_3.frame = CGRect(x: 10, y: 200, width: 100, height: 40)
        item_3.setBackgroundImage(UIImage.createImage(.blue), for: .normal)
//        item_2.backgroundColor = UIColor.red
        item_3.isEnabled = false
        
        let item_4 = UIButton(type: .detailDisclosure)
        item_4.setTitle("确定4", for: .normal)
        item_4.setTitleColor(UIColor.yellow, for: .normal)
        item_4.layer.cornerRadius = 22
        item_4.frame = CGRect(x: 10, y: 250, width: 100, height: 40)
        item_4.backgroundColor = UIColor.blue
        item_4.isEnabled = false
        
        self.view.addSubview(item)
        self.view.addSubview(item_2)
        self.view.addSubview(item_3)
        self.view.addSubview(item_4)

    }
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGes(sender:)))
        pan.delegate = self
        return pan
    }()
    
    @IBOutlet weak var graphicImageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard MMMainManager.shared.isPrintLifeLog else { return }
        if let present = UIViewController.currentViewController() {
            // <Swift_SweetSugar.UITestVC: 0x13f008e00>
            mm_printLog("test->\(present)")
        }
        print("test-> isViewLoaded4: \(isViewLoaded)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard MMMainManager.shared.isPrintLifeLog else { return }
        if let present = UIViewController.currentViewController() {
            //HomeListVC
            mm_printLog("test->\(present)")
        }
    }
    
//    override func viewIsAppearing(_ animated: Bool) {
//        super.viewIsAppearing(animated)
//        guard MMMainManager.shared.isPrintLifeLog else { return }
//        mm_printLog("test->appearing")
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard MMMainManager.shared.isPrintLifeLog else { return }
        if let present = UIViewController.currentViewController() {
            //UITestVC
            mm_printLog("test->\(present)")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard MMMainManager.shared.isPrintLifeLog else { return }
        if let present = UIViewController.currentViewController() {
            //HomeListVC
            mm_printLog("test->\(present)")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("test-> isViewLoaded5: \(isViewLoaded)")
    }
    
    var show = false
    var model = 200
    
    //MARK: - 从这里开始测试

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        mm_printLog("test->touch")
//        animationButton()
//        handleClick(sender: bar)
//        shadowTest()
//        playAnimation()
//        windowTest()
//        addActivity()
        
//        area()
//        textViewTest()
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        blurEffectView.effect = blurEffect
//
//        let arr = [1, 2,3 ,4,5]
//        for item in arr {
//            mm_printLog(item)
//        }
//        arr.forEach({ String(format: "test->%d", $0) })
//        numberOfLinesTest()
//        anchorTest()
//        layoutTest()
//        _compareView?.removeFromSuperview()
//        graTest()
//        snapshotTest()
//        gradientTest()
//        stackViewTest()
        //transform 测试 CGAffineTransform
//        transformTest()
//        playerTest()
//        gradientLabelTest()
//        pushVC()
//    }
    
    /// stackView 间距测试: 可以自定义某个 子视图之后的间距
    func stackViewTest() {
        //有效， 但是当 distribute 为 EqualSpacing 时 无效
//        stackView.setCustomSpacing(0, after: label2)
        stackView.alignment = .center
        stackView.distribution = .fill
        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        v.backgroundColor = .brown
        stackView.insertArrangedSubview(v, at: 0)
        
//        mm_printLog("test->\(stackView.arrangedSubviews)")
//        // 此方法也可以移除
//        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
//        mm_printLog("test->\(stackView.arrangedSubviews)")
    }
    
    /// 截图测试
    func snapshotTest() {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        v.backgroundColor = .green
        view.addSubview(v)
        
        let size = CGSize(300, 300)
        let rect = CGRect(x: 0, y: 0, width: 300, height: 300)
        let renderer = UIGraphicsImageRenderer(size: CGSize(300, 300))
        let renderImg = renderer.image { context in
            v.drawHierarchy(in: rect, afterScreenUpdates: true)
        }
        self.graphicImageView.image = renderImg
//
//        DispatchQueue.main.async {
//            UIGraphicsBeginImageContextWithOptions(CGSize(300, 300), false, UIScreen.main.scale)
//            guard let context = UIGraphicsGetCurrentContext() else { return }
//            self.stackView.draw(CGRect(x: 0, y: 0, width: 100, height: 100))
//            let img = UIGraphicsGetImageFromCurrentImageContext()
//            self.graphicImageView.image = img
//            UIGraphicsEndImageContext()
//        }
//
        return
    }
    
    func gradientTest() {
//        let layer0 = CAGradientLayer()
//        layer0.colors = [
//          UIColor(red: 0.078, green: 0.055, blue: 0.18, alpha: 1).cgColor,
//          UIColor(red: 0.145, green: 0.035, blue: 0.133, alpha: 1).cgColor
//        ]
//        layer0.locations = [0, 1]
//        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
//        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
//        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))
//        layer0.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
//        layer0.position = view.center
//        view.layer.addSublayer(layer0)
        
//        let layer0 = CAGradientLayer()
//        layer0.colors = [
//          UIColor(red: 1, green: 0.917, blue: 0.962, alpha: 1).cgColor,
//          UIColor(red: 0.796, green: 0.762, blue: 1, alpha: 1).cgColor
//        ]
//        layer0.locations = [0, 1]
//        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
//        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
//        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.73, b: -0.05, c: -0.77, d: -1.37, tx: 1.4, ty: 0.77))
        let time = NSDate()
//        // 性能比较 使用layer 内存低，速度快。
        for _ in 0...100 {
            let v = MMGradientView()
            view.addSubview(v)
            v.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.height.equalTo(200)
            }
            //        v.frame = CGRect(x: 100, y: 200, width: 300, height: 300)
            v.update(colors: [UIColor.brown,
                              UIColor.yellow,
                              UIColor.brown], start: CGPoint(x: 0.5, y: 0), end: CGPoint(x: 0.5, y: 1), locations: [0, 0.99,  1])

        }
        //"🔨[UITestVC gradientTest()](317): test->耗时:0.016939163208007812"
//        "🔨[UITestVC gradientTest()](318): test->耗时:0.058474063873291016"  真机 内存 23.2M - 22 = 1M
        mm_printLog("test->耗时:\(NSDate().timeIntervalSince1970 - time.timeIntervalSince1970)")
        
//        for _ in 0...100 {
//            let v = SampleGradientView()
//            view.addSubview(v)
//            v.snp.makeConstraints { make in
//                make.leading.trailing.equalToSuperview()
//                make.bottom.equalToSuperview().offset(-200)
//                make.height.equalTo(200)
//            }
//            v.colors = [UIColor(red: 0.212, green: 0.224, blue: 0.255, alpha: 0),
//                        UIColor(red: 0.212, green: 0.224, blue: 0.255, alpha: 0.7),
//                        UIColor(red: 0.212, green: 0.224, blue: 0.255, alpha: 1)]
//            v.locations =  [0, 0.3, 0.63, 1]
//
//        }
//        //test->耗时:0.019596099853515625"
//        //"🔨[UITestVC gradientTest()](336): test->耗时:0.06610107421875" 真机  0.1   286 - 22M = 264M
//        mm_printLog("test->耗时:\(NSDate().timeIntervalSince1970 - time.timeIntervalSince1970)")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog("test->touchesBegan")
//        animationButton()
        customDrawTest()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog("test->move")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog("test->cancel")
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        mm_printLog("test->press")
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        mm_printLog("test->motion")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if view.mm_width > view.mm_height {
////            graphicImageView.layer.masksToBounds = true
//            graphicImageView.layer.cornerRadius = 50
//            scrollBgView.snp.updateConstraints { make in
//                make.height.equalTo(500)
//                make.trailing.equalToSuperview().offset(-400)
//            }
//        } else {
//            graphicImageView.layer.cornerRadius = 0
//            scrollBgView.snp.updateConstraints { make in
//                make.height.equalTo(300)
//                make.trailing.equalToSuperview()
//            }
//        }
    }
    
    lazy var scrollBgView: UIView = {
        let item = UIView()
        self.view.addSubview(item)
        return item
    }()

    
    lazy var scrollView: UIScrollView = UIScrollView()
    
    func layoutTest() {
        view.addSubview(scrollBgView)
        scrollBgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        scrollBgView.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let bg = UIView()
        bg.backgroundColor = UIColor.brown.withAlphaComponent(0.6)
        scrollView.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.height.equalToSuperview()
        }
//        graphicImageView.backgroundColor = UIColor.init(white: 0.1, alpha: 0.001)
//        graphicImageView.layer.cornerRadius = 50
        bg.addSubview(graphicImageView)
        graphicImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            self.layoutTest2()
//        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    func layoutTest2() {
        shadowView.snp.updateConstraints { make in
            make.height.equalTo(200)
        }
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    func area() {
        let h = kBottomSafeHeight
        mm_printLog(h)
    }
    
    func email() {
        if !MFMailComposeViewController.canSendMail() {
            //不支持发送邮件
            mm_printsLog("不支持？")
            UIApplication.shared.open(URL(string: "mailto:123456789@qq.com")!, options: [:], completionHandler: nil)
            return
        } else {
            //支持发送邮件
        }
        let mail = MFMailComposeViewController()
        mail.navigationBar.tintColor = UIColor.brown //导航颜色
        mail.setToRecipients(["123456789@qq.com"]) //设置收件地址
        mail.setCcRecipients(["123456789@qq.com"]) //添加抄送
        mail.setBccRecipients(["123456789@qq.com"]) //秘密抄送
        mail.mailComposeDelegate = self //代理

        mail.setSubject("邮件标题")
        //发送文字
        mail.setMessageBody("文字内容", isHTML: false) //邮件主体内容
        //发送图片
//        let imageData: NSData = UIImagePNGRepresentation(UIImage(named: "图片名字")!)! as NSData
//        mail.addAttachmentData(imageData as Data, mimeType: "", fileName: "图片名字.png")

        present(mail, animated: true, completion: nil)
//        dismiss(animated: true)
//        labelTest()
        showVC()
    }
    
    func showVC() {
        let vc = FuncTestVC()
        //push
        show(vc, sender: self)
        //present
        showDetailViewController(vc, sender: self)
    }
    
    func pushVC() {
        let vc = FuncTestVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func playAnimation() {
        inputIconLotView.play { finish in
            mm_printLog("test->\(finish)")
        }
    }
    
    func addActivity() {
        let act = NSUserActivity(activityType: "mumu")
        act.title = "UI测试"
        act.keywords = ["you", "test", "good"]
        act.isEligibleForHandoff = true
        act.isEligibleForSearch = true
//        activity.isEligibleForPublicIndexing = false;
        userActivity = act
        act.becomeCurrent()
    }
    
    func windowTest() -> Void {
//        let alert = UIAlertController(title: "title", message: "文字", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
//
//        }))
//        navigationController?.present(alert, animated: true, completion: nil)
        
        let newW = UIWindow(frame: UIScreen.main.bounds)
        newW.backgroundColor = .lightGray
        newW.rootViewController = FuncTestVC()
//        newW.makeKeyAndVisible()
        newW.isHidden = false
        newWindow = newW
        DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + 2) {
            newW.isHidden = true
            self.newWindow = nil
        }
    }
    
    func convertRect() {
        //▿ Optional<UIView>
//        - some : <UIView: 0x7fe28380a440; frame = (10 150; 100 50); autoresize = RM+BM; layer = <CALayer: 0x600001ff5460>>
//      Printing description of $19:
//      <UIView: 0x7fe28380a440; frame = (10 -200; 100 50); autoresize = RM+BM; layer = <CALayer: 0x600001ff5460>>
        var applyFrame = shadowView.frame.applying(CGAffineTransform(scaleX: 1.0, y: -1))
        applyFrame.origin.y = 100
        shadowView.frame = applyFrame
    }
    
    func scrollTextView() {
        self.textView.scrollRectToVisible(CGRect(x: 0, y: 15, width: 1, height: 1), animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: {
            self.textView.becomeFirstResponder()
        })
//        textView.sele
//        textView.scrollRectToVisible(CGRect(x: 0, y: 15, width: 1, height: 1), animated: true)
    }
    
    func shadowTest() {
        
        shadowBtn.layer.shadowColor = UIColor.black.cgColor
        shadowBtn.layer.shadowRadius = 20
        shadowBtn.layer.shadowOffset = CGSize(0, 4)
        shadowBtn.layer.shadowOpacity = 1
    }
    
    func alertShow() {
        let alert = UIAlertController.init(title: "确定删除历史?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "", style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction(title: "", style: .cancel, handler: { _ in
            
        }))
        navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func changeImgSize() {
        mm_printLog(changeImageSizeBtn.mm_size)
        mm_printLog(changeImageSizeBtn.imageView?.mm_size)
        changeImageSizeBtn.imageView?.mm_size = CGSize(width: 50, height: 50)
    }
    
    //锚点对动画的影响
    func anchorTest() {
//        shadowView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
//        let transFrom = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        UIView.animate(withDuration: 0.5) {
//            self.shadowView.transform = transFrom
//        }
        shadowView.mm_y += 50
        _compareView?.mm_y += 50
        /*
         [UITestVC viewDidLoad()](86): center->(60.0, 184.0),frame->(10.0, 159.0, 100.0, 50.0)
         [UITestVC anchorTest()](134): center->(60.0, 210.0),frame->(-40.0, 210.0, 100.0, 50.0)
         */
//        shadowView.layer.anchorPoint = CGPoint(x: 1, y: 0)
//        mm_printLog("center->\(shadowView.center),position->\(shadowView.layer.position),frame->\(shadowView.frame)")
//        let nowFrame = shadowView.frame
//        let x = nowFrame.minX  + 100 * 0.5
//        let y = nowFrame.minY - 50 * 0.5
//        shadowView.origin = CGPoint(x: x, y: y)
//        mm_printLog("center->\(shadowView.center),position->\(shadowView.layer.position),frame->\(shadowView.frame)")

    }
    
    // 添加粒子效果
    func addEmitter() {
        
        // 1.创建发射器
        emitter = CAEmitterLayer()
        guard let emitter = self.emitter else { return }
        // 2.发射器位置
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y:  -20)
        // 3.开启三维效果
        emitter.preservesDepth = true
        // 4.设置 Cell(对应其中一个粒子)
        // 4.0.创建粒子
        let cell = CAEmitterCell()
        // 4.1.每秒发射粒子数
        cell.birthRate = 3
        // 4.2.粒子存活时间
        cell.lifetime = 5
        cell.lifetimeRange = 2.5
        // 4.3.缩放比例
        cell.scale = 0.7
        cell.scaleRange = 0.3
        // 4.4.粒子发射方向
        cell.emissionLongitude = CGFloat.pi * 0.5
        cell.emissionRange = CGFloat.pi * 0.25
        // 4.5.粒子速度
        cell.velocity = 150
        cell.velocityRange = 50
        // 4.6.旋转速度
        cell.spin = CGFloat.pi * 0.5
        // 4.7.粒子内容
        cell.contents = UIImage(named: "carrot6")?.cgImage
        // 5.将粒子添加到发射器中
        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
    }
    
    func videoTest() -> Void {
        self.pictureVC?.startPictureInPicture()
        var count: UInt32 = 0
        let list = class_copyIvarList(AVPictureInPictureController.self, &count)
        
        for i in 0..<count {
            let ivar = list?[Int(i)]
            var emptyCChar: CChar = 1
            let name = ivar_getName(ivar!) ?? UnsafePointer<CChar>(&emptyCChar)
            
            let str = String(cString: name)
            mm_printLog("->\(str)")
        }
//        let simplePlayerLayerView = pictureVC?.value(forKeyPath: "_playerLayer")
        let _AVPlayerController = pictureVC?.value(forKeyPath: "_playerController")
        let _observationController = pictureVC?.value(forKeyPath: "_observationController")
//        let layerView = pictureVC?.value(forKey: "AVPictureInPicturePlayerLayerView")
//        let simpleLayerView = pictureVC?.value(forKey: "_AVSimplePlayerLayerView")
        mm_printLog("")
    }
    
    func setupPip() {
        if AVPictureInPictureController.isPictureInPictureSupported() {
            do {
//                let error: AVAudioSession.SetActiveOptions
                try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                pictureVC = AVPictureInPictureController(playerLayer: avPlayerLayer)
                pictureVC?.delegate = self
                avPlayer.play()
            } catch let e {
                mm_printLog(e)
            }
        } else {
            avPlayer.play()
        }
    }
    
    /// 测试结果 lineFragmentPadding + textContainerInset 为最终内边距
    func textViewTest() {
        textView.text = ""
//        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
//        //两边间距
//        textView.textContainer.lineFragmentPadding = 20
        
        //新属性测试
//        textView.textContentType = .newPassword
//        textView.isSecureTextEntry = true
//        //大写，小写、连续字符次数最大值、最小长度
//        let descriptor = "required: upper; required: lower; required: special; max-consecutive: 3; minlength: 8;"
//        let rules = UITextInputPasswordRules(descriptor: descriptor)
//        textView.passwordRules = rules
//        textView.smartDashesType = .no
        
        let text = "The appropriate bgText The appropriate word elu"
        let attr = NSMutableAttributedString(string: text)
        attr.addAttributes([.backgroundColor: UIColor.brown,
                            .foregroundColor: UIColor.green], range: NSRange(location: 4, length: 5))
        textView.attributedText = attr
    }
    
    /// 测试结果，会根据最大行数返回size，也会根据约束的宽度，计算合适的结果
    func numberOfLinesTest() {
        //lineheight: 20: 23.8671875 21: 25.06
        let font = UIFont.systemFont(ofSize: 21)
        widthLabel.font = font
        widthLabel.numberOfLines = 2
        let size = widthLabel.intrinsicContentSize
        widthLabel.mm_size = size
        mm_printLog("test->\(size)")
        
        return
        mm_printLog("print_test")
    }

    
    func setupAttr() -> Void {
        let str = "Your project does not explicitly specify the CocoaPodsmassdfssdfter specs repo. Since CDN is now used as the default, you may safely remove it from your repos directory via `pod repo remove master`. To suppress this warning please add `warn_for_unused_master_specs_repo => false` to your Podfile"
        
        let attr = NSMutableAttributedString(string: str)
        attr.addAttribute(NSAttributedString.Key.font, value: attrText.font, range: str.mm_range())
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_voice_3"), for: .normal)
        btn.mm_size = CGSize(width: 18, height: 18)
        
        let attach = NSAttributedString.yy_attachmentString(withContent: btn, contentMode: .center, attachmentSize: btn.mm_size, alignTo: attrText.font, alignment: .center)
        
        attr.append(attach)
        let container = YYTextContainer(size: CGSize(width: 200, height: .max))
        
        let layout = YYTextLayout(container: container, text: attr)
        
        if let lines = layout?.lines, (layout?.lines.count ?? 0) > 20 {
            let maxRange = lines[1]
            guard var subAttr = attr.attributedSubstring(from: NSRange(location: 0, length: NSMaxRange(maxRange.range))).mutableCopy() as? NSMutableAttributedString else {
                return
            }
            let suffixAttr = beyondAttach()
            //判断是否有换行
            let tmpSubAttr = subAttr.mutableCopy() as! NSMutableAttributedString
            tmpSubAttr.append(suffixAttr)
            let tmpLayout = YYTextLayout(container: container, text: tmpSubAttr)
            
            var fitLayout: YYTextLayout?
            
            if (tmpLayout?.lines.count ?? 0) > 2 {
                //多减去1个字符
                subAttr.replaceCharacters(in: NSRange(location: subAttr.length - suffixAttr.length - 1, length: suffixAttr.length), with: suffixAttr)
                fitLayout = YYTextLayout(container: container, text: subAttr)
            } else {
                fitLayout = tmpLayout
                subAttr = tmpSubAttr
            }
            
            attrText.attributedText = subAttr
            attrText.mm_x = 50
            attrText.mm_y = 200
            attrText.mm_size = CGSize(width: 200, height: fitLayout?.textBoundingSize.height ?? 0)
//        }
        } else {
        attrText.attributedText = attr
//                    attrText.textLayout = layout
        attrText.mm_x = 50
                   attrText.mm_y = 200
        attrText.mm_size = CGSize(width: 200, height: layout?.textBoundingSize.height ?? 0)
    }
        mm_printLog("")
    }

    func beyondAttach() -> NSAttributedString {
        let attr = NSMutableAttributedString(string: " ...")
        attr.addAttribute(NSAttributedString.Key.font, value: attrText.font, range: attr.yy_rangeOfAll())
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_voice_3"), for: .normal)
        btn.mm_size = CGSize(width: 18, height: 18)
        let attach = NSAttributedString.yy_attachmentString(withContent: btn, contentMode: .center, attachmentSize: btn.mm_size, alignTo: attrText.font, alignment: .center)

        attr.append(attach)
        
        return attr
    }
    var str = "Your project does not explicitly specify"
    @objc func handleClick(sender: UIButton) {
        
//        str += " a"
//        let attr = getInputAttr(input: str, font: UIFont.systemFont(ofSize: 20))
//
//        let number = attr.numberOfLine(width: 150)
//
//        mm_printLog("点击了->\(number)")
//
//        textView.attributedText = attr
        textViewTest()
    }
    
    /// 视频播放器测试
    func playerTest() {
        guard avPlayerLayer.superlayer == nil else { return }
        view.layer.addSublayer(avPlayerLayer)
//        avPlayer.play()
        // 开启画中画
        setupPip()
    }
    
}
extension UITestVC {
    func animationButton() {
//        self.testButton.setTitle(nil, for: .normal)
//        self.testButton.setImage(UIImage(named: "btn_heart_selected"), for: .normal)
//        testButton.layer.cornerRadius = 15
//        testButton.imageView?.transform = .identity
//        let imgTransform = CGAffineTransform(scaleX: 4, y: 4)
//        imgTransform.rotated(by: CGFloat.pi)
//        var confi = customButton.configure
//        confi.image = confi.selectedImage
//        customButton.setConfigure(con: confi)
//        
//        let scaleAni = CAKeyframeAnimation(keyPath: "transform.scale")
//        scaleAni.values = [0.8, 1.2, 1.5, 1.2, 1]
//        scaleAni.keyTimes = [0, 0.2, 0.5, 0.8, 1]
//        scaleAni.duration = 2
//        scaleAni.timingFunction =  CAMediaTimingFunction(name: .easeInEaseOut)
//        customButton._imageView.layer.add(scaleAni, forKey: nil)
//        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            UIView.animate(withDuration: 1) {
//                self.customButton.isYDSelected = true
//                self.customButton.snp.updateConstraints { make in
//                    make.size.equalTo(self.customButton.fitSizeContent(1))
//                }
//                self.view.layoutIfNeeded()
//            } completion: { _ in
//                
//            }
//        }
        // 创建一个UIView对象
//        let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        // 设置layer的borderWidth属性
        resetImageView.layer.borderWidth = 3.0
        self.resetImageView.layer.borderColor = nil
        // 使用UIView.animate的block方法来执行动画
        UIView.animate(withDuration: 0.5) {
            self.resetImageView.layer.borderWidth = 10
            // 将layer的borderColor属性从红色变为蓝色
            self.resetImageView.layer.borderColor = UIColor.blue.cgColor
        }

//        UIView.animate(withDuration: 1) {
//            self.testButton.imageView?.transform = imgTransform
//
//            self.testButton.transform = CGAffineTransform(scaleX: 2, y: 2)
//        } completion: { _ in
//
//        }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            UIView.animate(withDuration: 1) {
//                self.testButton.imageView?.transform = .identity
//                self.testButton_width.constant = 50
//    //            self.testButton.isSelected = true
//                self.view.layoutIfNeeded()
//            } completion: { _ in
//                
//            }
//        }

    }
}
extension UITestVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        mm_printLog("textViewDidChange")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        mm_printLog("shouldChangeTextIn")
        return true
    }
}

extension UITestVC: AVPictureInPictureControllerDelegate {
    func pictureInPictureControllerWillStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        mm_printLog("WillStart")
    }
    func pictureInPictureControllerDidStartPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        mm_printLog("DidStart")
    }
    func pictureInPictureControllerDidStopPictureInPicture(_ pictureInPictureController: AVPictureInPictureController) {
        mm_printLog("DidStop")
    }
}



extension UITestVC: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        mm_printLog("test->gesture \(gestureRecognizer), other: \(otherGestureRecognizer)")
//        if gestureRecognizer is UITapGestureRecognizer {
//            return true
//        }
//        return false
//    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        mm_printLog("test->gesture \(gestureRecognizer), other: \(otherGestureRecognizer)")
//
//        if !(gestureRecognizer is UIPanGestureRecognizer) {
//            return true
//        }
//        return false
//    }

//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        mm_printLog("test->gesture2: \(gestureRecognizer), \\n other: \(otherGestureRecognizer)")
//        return true
//    }
    
    @objc func handlePanGes(sender: UIPanGestureRecognizer) {
//        guard !isFullScreen else { return }
        let translation: CGPoint = sender.translation(in: sender.view!)
        mm_printLog("test->pan:\(translation)")
        switch sender.state {
        case .began: //开始记录
            break
//            scrollViewWillBeginDragging(webView.scrollView)
        case .changed:
//            handleOffsetY(offsetY: translation.y)
            if translation.y < -50 {
                panGesture.isEnabled = false
            }
        case .ended, .cancelled:
            break;
//            handleOffsetY(offsetY: translation.y)
//            scrollViewDidEndDragging(webView.scrollView, willDecelerate: true)
        default:
            break
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
//        let translation: CGPoint = sender.translation(in: sender.view!)
        mm_printLog("test->tap:\(sender)")
    }
}

extension UITestVC {
    func getInputAttr(input: String, font: UIFont) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5.0
        let attribute = NSAttributedString(string: input,
                                           attributes: [
                                            NSAttributedString.Key.paragraphStyle: paragraph,
                                            NSAttributedString.Key.font: font as Any,
//                                            NSAttributedString.Key.kern: 0.01
                                           ])
        return attribute
    }
    
    func showAnimation() -> Void {
//        view.layoutIfNeeded()
//        let transfrom = CGAffineTransform(scaleX: 0.4, y: 0.4)
//        shadowView.transform = transfrom
//        let origin = shadowView.origin
//
//        shadowView.origin = CGPoint(x: origin.x + shadowView.mm_width * 0.5, y: origin.y - shadowView.mm_height * 0.5)

//        shadowView.origin = CGPoint(x: 100, y: 200)
        let base = CABasicAnimation(keyPath: "transform.scale")
        base.fromValue = 0.4
        base.toValue = 1

//        base.
        shadowView.layer.add(base, forKey: "scale")
   
    }
    func dismiss() -> Void {
        let base = CABasicAnimation(keyPath: "transform.scale")
        base.fromValue = 1
        base.toValue = 0.4
        
//        base.
        shadowView.layer.add(base, forKey: "dismiss")
    }
    
    func create(width: CGFloat) -> UIImage? {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.mm_colorFromHex(color_vaule: 0xCDF4FF).cgColor,
                        UIColor.mm_colorFromHex(color_vaule: 0xB1ECFE).cgColor,
                        UIColor.mm_colorFromHex(color_vaule: 0xCDF4FF).cgColor]
        layer.startPoint = .zero
        layer.endPoint = CGPoint(x: 1, y: 0);
        layer.locations = [0,0.61,1.0]
        let frame = CGRect(x: 0, y: 0, width: width, height: 1)
        layer.frame = frame
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: 1), false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UITestVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class MMPassthroughView: UIView {
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        let view = super.hitTest(point, with: event)
//        print("点击->\(event!)")
//        return view == self ? nil : view
//    }
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//            if let result = super.hitTest(point, with: event) {
//                        print("点击->\(event?.allTouches)")
//                if result == self && event?.allTouches?.first?.gestureRecognizers?.contains(where: { $0 is UIPanGestureRecognizer }) == true {
//                    return self
//                } else {
//                    return nil
//                }
//            }
//            return nil
//        }
}
