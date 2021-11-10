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
    
    lazy var customButton: YDCustomButton = {
        let item = YDCustomButton()
        item.backgroundColor = .blue
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
        label.backgroundColor = .cyan
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
    
    var pictureVC: AVPictureInPictureController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
//        shadowView.layer.cornerRadius = 24
      //        layer.shadowColor = UIColor(hex: 0x3C4D59, alpha: 0.9).cgColor
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 1
        shadowView.frame = CGRect(x: 10, y: 150, width: 100, height: 50)
//        shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        
        let shadowSub = UIView(frame: CGRect(x: 0, y: 10, width: 30, height: 30))
        shadowSub.backgroundColor = .red
        shadowView.addSubview(shadowSub)
        mm_printLog("center->\(shadowView.center),position->\(shadowView.layer.position),frame->\(shadowView.frame)")
        //位置比较
        let compareView = UIView(frame: shadowView.frame)
        compareView.backgroundColor = .red
        view.insertSubview(compareView, belowSubview: shadowView)

        let line: MMDottedLine = MMDottedLine()
        line.mm_size = CGSize(width: 100, height: 10)
//        line.test()
        line.mm_y = 100
        view.addSubview(line)
        
        view.addSubview(attrText)

//        DispatchQueue.main.async {
//            let origin = self.shadowView.origin
//            self.shadowView.origin = CGPoint(x: origin.x + self.shadowView.mm_width * 0.5, y: origin.y - self.shadowView.mm_height * 0.5)
//        }
        widthLabel.text = "大约两行高度的文字试一下"
//        view.layer.addSublayer(avPlayerLayer)
//        setupPip()
        
        pieChartView.colors = [.red,.blue,.green, .yellow]
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
//        shadowBtn.shadowPath = UIBezierPath(ovalIn:  CGRect(x: 0, y: 0, width: 50, height: 50)).cgPath

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    var show = false
    var model = 200
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        animationButton()
//        handleClick(sender: bar)
//        shadowTest()
        scrollTextView()
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
    
    func anchorTest() {
        /*
         [UITestVC viewDidLoad()](86): center->(60.0, 184.0),frame->(10.0, 159.0, 100.0, 50.0)
         [UITestVC anchorTest()](134): center->(60.0, 210.0),frame->(-40.0, 210.0, 100.0, 50.0)
         */
        shadowView.layer.anchorPoint = CGPoint(x: 1, y: 0)
        mm_printLog("center->\(shadowView.center),position->\(shadowView.layer.position),frame->\(shadowView.frame)")
        let nowFrame = shadowView.frame
        let x = nowFrame.minX  + 100 * 0.5
        let y = nowFrame.minY - 50 * 0.5
        shadowView.origin = CGPoint(x: x, y: y)
        mm_printLog("center->\(shadowView.center),position->\(shadowView.layer.position),frame->\(shadowView.frame)")

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
        
        let text = "bgText"
        let attr = NSMutableAttributedString(string: text)
        attr.addAttributes([.backgroundColor: UIColor.red,
                            .foregroundColor: UIColor.green], range: NSRange(location: 0, length: 3))
        textView.attributedText = attr
    }
    
    /// 测试结果，会根据最大行数返回size，也会根据约束的宽度，计算合适的结果
    func numberOfLinesTest() {
        widthLabel.numberOfLines = 2
        let size = widthLabel.intrinsicContentSize
        widthLabel.mm_size = size
    }
    
    /// 结论：transform 会改变frame
    func transformTest() {
                mm_printLog("mode=\(NSLineBreakMode(rawValue: model)!.rawValue)")
//                mm_printLog("\(textView)")
                textView.transform = CGAffineTransform(scaleX: 1, y: 1.2)
//                mm_printLog("\(textView)")
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
        
        str += " a"
        let attr = getInputAttr(input: str, font: UIFont.systemFont(ofSize: 20))
        
        let number = attr.numberOfLine(width: 150)
        
        mm_printLog("点击了->\(number)")
        
        textView.attributedText = attr
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
        var confi = customButton.configure
        confi.image = confi.selectedImage
        customButton.setConfigure(con: confi)
        
        let scaleAni = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAni.values = [0.8, 1.2, 1.5, 1.2, 1]
        scaleAni.keyTimes = [0, 0.2, 0.5, 0.8, 1]
        scaleAni.duration = 2
        scaleAni.timingFunction =  CAMediaTimingFunction(name: .easeInEaseOut)
        customButton._imageView.layer.add(scaleAni, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            UIView.animate(withDuration: 1) {
                self.customButton.isYDSelected = true
                self.customButton.snp.updateConstraints { make in
                    make.size.equalTo(self.customButton.fitSizeContent(1))
                }
                self.view.layoutIfNeeded()
            } completion: { _ in
                
            }
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
