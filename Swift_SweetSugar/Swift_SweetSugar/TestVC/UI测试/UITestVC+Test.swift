//
//  UITestVC+Test.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/2/9.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit
import Kingfisher

extension UITestVC {
    
    /// 绘制高亮
    func customDrawTest() {
        customDrawView?.removeFromSuperview()
        
        let _customDrawView = MMHighlightView()
//        _customDrawView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        // 不设置背景色，会在draw中默认为黑色背景
        _customDrawView.backgroundColor = .clear
        view.addSubview(_customDrawView)
        _customDrawView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(200)
        }
        customDrawView = _customDrawView
    }
    
    func netImageTest() {
        guard let url = URL(string: "https://ydlunacommon-cdn.nosdn.127.net/8f904fdab0f5b3d49b1d180b0e712d49.png") else { return }
//        guard let url = URL(string: "https://ydlunacommon-cdn.nosdn.127.net/2b2fdeb4cc1356c822faa7621de10c2a.gif") else { return }
        netImageView.kf.setImage(with: url)
//        view.addSubview(netAniImageView)
//        netAniImageView.snp.makeConstraints { make in
//            make.edges.equalTo(netImageView)
//        }
//        netAniImageView.kf.setImage(with: url)
        DispatchQueue.global(qos: .utility).async {
            guard !ImageCache.default.isCached(forKey: url.absoluteString) else { return }
//            var info = KingfisherOptionsInfo()
//            info.dic
            KingfisherManager.shared.retrieveImage(with: url) { result in
                if case .success(let image) = result {
                    print("Downloaded Image: \(image)")
                } else {
                    print("Download failed")
                }
                switch result {
                case .success(let res):
                    mm_printLog(res.image)
                case .failure(let error):
                    mm_printLog(error)
                }
                mm_printLog("test-> \(ImageCache.default.isCached(forKey: url.absoluteString))")
                //                mm_printLog("test-> \(ImageCache.default.isCached(forKey: url.absoluteString.MD5String))")
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
                    mm_printLog("test-> \(ImageCache.default.isCached(forKey: url.absoluteString))")
                }
            }
//            ImageDownloader.default.downloadImage(with: url, options: [.targetCache(.default)]) { result in
//                mm_printLog("下载->完成")
//                switch result {
//                case .success(let res):
//                    mm_printLog(res.image)
//                case .failure(let error):
//                    mm_printLog(error)
//                }
//                ImageCache.default.cache
//                mm_printLog("test-> \(ImageCache.default.isCached(forKey: url.absoluteString))")
////                mm_printLog("test-> \(ImageCache.default.isCached(forKey: url.absoluteString.MD5String))")
//                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 2) {
//                    mm_printLog("test-> \(ImageCache.default.isCached(forKey: url.absoluteString))")
//                }
//            }
            mm_printLog("下载->")
        }
    }
    
    func labelTest() {
        let pg = NSMutableParagraphStyle()
        pg.lineBreakMode = .byTruncatingTail
        
        let attr = NSMutableAttributedString(string: "0123")
        attr.addAttribute(.paragraphStyle, value: NSMutableParagraphStyle(), range: NSRange(location: 0, length: 4))
        
        let attr_2 = NSMutableAttributedString(string: "456")
        attr_2.addAttribute(.paragraphStyle, value: pg, range: NSRange(location: 0, length: 3))
        
        attr.append(attr_2)
        
        widthLabel.attributedText = attr
    }
    
    func hanshushiTest() -> Void {
        guard let url = URL(string: "http://www.objc.io/images/covers/16.jpg"), let image = CIImage(contentsOf: url) else { return }
        
        let blurRadius = 5.0
        let overlayColor = UIColor.red.withAlphaComponent(0.2)
        let blurredImage = tool.blur(radius: blurRadius)(image)
        let overlaidImage = tool.colorOverlay(color: overlayColor)(blurredImage)
        
    }
    
    func gradientLabelTest() {
        
        gradientLabelTest3()
        return
        
        let label = UILabel()
        label.text = "这是一段文本文本wenbesdfjslkafjlsk"
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
//        view.addSubview(label)
//        label.snp.makeConstraints { make in
//            make.edges.equalTo(gradientView)
//        }
        
//        gradientView.layer.mask = label.layer
//        label.frame = CGRect(x: 100, y: 400, width: 300, height: 300)
        
        let gradientView = MMGradientView()
        view.addSubview(gradientView)
        gradientView.addSubview(label)
        gradientView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(label.mm_width)
        }
        gradientView.update(colors: [UIColor.mm_colorFromHex(color_vaule: 0x7d42d4),
                                     UIColor.mm_colorFromHex(color_vaule: 0x534dd1),
                                     UIColor.mm_colorFromHex(color_vaule: 0x78a0e5)], start: CGPoint(x: 0, y: 0.5), end: CGPoint(x: 1, y: 0.5), locations: [0.2, 0.5,  1])
        gradientView.layer.mask = label.layer
        label.frame = gradientView.bounds
    }
    
    func gradientLabelTest3() {
        if gradientLabel.superview != nil {
//            gradientLabel.isHidden = !gradientLabel.isHidden
            let a = "absdfsdfdsjfkjsadhfkjsdhfkjsd"
            let b = "哥告诉你个水果蛋糕时高时低广东省高手打干撒搭嘎手打干撒搭嘎手打干撒搭嘎"
            if gradientLabel.text == a {
                gradientLabel.text = b
                gradientLabel.mm_width = 100
            } else {
                gradientLabel.text = a
                gradientLabel.mm_width = 250
            }
            return
        }
        gradientLabel.text = "你个水果蛋糕时高时低广东省高手打干撒搭嘎手打干撒搭嘎手打干"
        view.addSubview(gradientLabel)
        gradientLabel.frame = CGRect(origin: CGPoint(x: 100, y: 200), size: CGSize(250, 30))
//        gradientLabel.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-40)
//        }
//        label.text = "必须要把Label添加到view上，如果不添加到view上，label的图层就不会调用drawRect方法绘制文字，也就没有文字裁剪了。"
    }
    
    func gradientLabelTest2() {
        // 创建UILabel
        let label = UILabel()

        label.text = "专注于高级iOSsdfsdfasdfsdfasdf"

        label.sizeToFit()

        label.center = CGPoint(x: 200, y: 100)
        // 必须要把Label添加到view上，如果不添加到view上，label的图层就不会调用drawRect方法绘制文字，也就没有文字裁剪了。
        // 如何验证，自定义Label,重写drawRect方法，看是否调用,发现不添加上去，就不会调用
        self.view.addSubview(label)

        // 创建渐变层
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = label.frame
        // 设置渐变层的颜色，随机颜色渐变
//        gradientLayer.colors = [self.randomColor().cgColor, self.randomColor().cgColor, self.randomColor().cgColor]
        gradientLayer.colors = [
            UIColor.mm_colorFromHex(color_vaule: 0x7d42d4).cgColor,
            UIColor.mm_colorFromHex(color_vaule: 0x534dd1).cgColor,
            UIColor.mm_colorFromHex(color_vaule: 0x78a0e5).cgColor,
        ]
        // 疑问:渐变层能不能加在label上
        // 不能，mask原理：默认会显示mask层底部的内容，如果渐变层放在mask层上，就不会显示了

        // 添加渐变层到控制器的view图层上
        self.view.layer.addSublayer(gradientLayer)

        // mask层工作原理:按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
        // 设置渐变层的裁剪层
        gradientLayer.mask = label.layer

        // 注意:一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层，这样做的目的：以渐变层为 坐标系，方便计算裁剪区域，如果以其他层为坐标系，还需要做点的转换，需要把别的坐标系上的点，转换成自己坐标系上点，判断当前点在不在裁剪范围内，比较麻烦。

        // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
        label.frame = gradientLayer.bounds
    }
    
    // 随机颜色方法
    func randomColor() -> UIColor {
    let r = CGFloat(arc4random_uniform(256)) / 255.0
    let g = CGFloat(arc4random_uniform(256)) / 255.0
    let b = CGFloat(arc4random_uniform(256)) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
