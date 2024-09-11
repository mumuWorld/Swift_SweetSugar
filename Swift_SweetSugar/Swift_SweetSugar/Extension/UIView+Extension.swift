//
//  UIView+Extension.swift
//  MMQRCode
//
//  Created by yangjie on 2019/8/5.
//  Copyright © 2019 yangjie. All rights reserved.
//

import UIKit

extension UIView {
    func checkSubViewRemove(checkViewStr: String) -> Void {
        if self.subviews.count < 1 {
            return
        }
        for subView in self.subviews {
            let str = String(describing: type(of: subView))
            if str == checkViewStr {
                subView.removeFromSuperview()
            }
        }
    }
    
    func removeAllSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UIView {
    
    static var skeletonView = "MMSkeletonView"
    
    var mm_skeletonView: MMSkeletonView? {
        get { return objc_getAssociatedObject(self, &UIView.skeletonView) as? MMSkeletonView }
        set { objc_setAssociatedObject(self, &UIView.skeletonView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func showSkeleton() {
//        // 创建渐变层
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer.frame = self.bounds
//        
//        // 定义渐变颜色
//        let lightColor = UIColor(white: 0.85, alpha: 1.0).cgColor
//        let darkColor = UIColor(white: 0.75, alpha: 1.0).cgColor
//        gradientLayer.colors = [lightColor, darkColor, lightColor]
//        
//        // 设置渐变的位置
//        gradientLayer.locations = [0.0, 0.5, 1.0]
//        
//        // 添加动画
//        let animation = CABasicAnimation(keyPath: "locations")
//        animation.fromValue = [0.0, 0.0, 0.25]
//        animation.toValue = [0.75, 1.0, 1.0]
//        animation.duration = 1.5
//        animation.repeatCount = .infinity
//        
//        gradientLayer.add(animation, forKey: "skeletonAnimation")
//        
//        // 将渐变层添加到视图
//        self.layer.addSublayer(gradientLayer)
        
        let v = MMSkeletonView()
        superview?.addSubview(v)
        v.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        v.show()
        mm_skeletonView = v
    }
    
    func hideSkeleton() {
        mm_skeletonView?.dismiss()
//        // 移除骨架动画
//        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
    }
}

class MMSkeletonView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        addDynamicViews()
//        show()
    }
    
    func addDynamicViews() {
        guard isHidden == false else { return }
        guard mm_height > 17 else { return }
//        removeAllSubviews()
        let lineSpace: CGFloat = 10
        let singleH: CGFloat = 17
        let count: Int = Int(mm_height / (singleH + lineSpace))
        
        var curY: CGFloat = 0
        for i in 0..<count {
            let layer = CAGradientLayer()
            layer.anchorPoint = .zero
//            layer.startPoint = CGPoint(x: 0, y: 0.5)
//            layer.endPoint = CGPoint(x: 1, y: 0.5)
            layer.cornerRadius = 4
            layer.name = CALayer.Constants.skeletonSubLayersName
            layer.frame = CGRect(x: 2, y: curY, width: mm_width - 4, height: singleH)
            // 定义渐变颜色
            let lightColor = UIColor.mm_colorFromHex(color_vaule: 0xecf0f1).cgColor
            let lightColorMiddle =  UIColor.mm_colorFromHex(color_vaule: 0xecf0f1).adjust(by: 0.94).cgColor
            let darkColor = UIColor.mm_colorFromHex(color_vaule: 0x1c2325).cgColor
            layer.colors = [lightColor, lightColorMiddle, lightColor]
            gradientLayer.addSublayer(layer)

            if i == count - 1, i != 0 {
                layer.mm_width = mm_width * 0.7
            }
            curY += singleH + lineSpace
            addAnimation(layer: layer)
        }
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.anchorPoint = .zero

        // 定义渐变颜色
//        let lightColor = UIColor.mm_colorFromHex(color_vaule: 0xecf0f1).cgColor
//        let darkColor = UIColor.mm_colorFromHex(color_vaule: 0x1c2325).cgColor
//        gradientLayer.colors = [lightColor, darkColor, lightColor]
        
        // 设置渐变的位置
//        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = self.bounds
        layer.addSublayer(gradientLayer)
//        layer.mask = gradientLayer
        return gradientLayer
    }()
    
    func show() {
//        layer.removeAllAnimations()
        isHidden = false
    }
    
    func addAnimation(layer: CALayer) {
        
        let animation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        animation.fromValue = 0.5
        animation.toValue = 1
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "opacity")
//        let startPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.startPoint))
//        startPointAnim.fromValue = CGPoint(x: -1, y: 0.5)
//        startPointAnim.toValue = CGPoint(x: 1, y: 0.5)
//        
//        let endPointAnim = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.endPoint))
//        endPointAnim.fromValue = CGPoint(x: 0, y: 0.5)
//        endPointAnim.toValue = CGPoint(x: 2, y: 0.5)
//        
//        let animGroup = CAAnimationGroup()
//        animGroup.animations = [startPointAnim, endPointAnim]
//        animGroup.duration = 1.5
//        animGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
//        animGroup.repeatCount = .infinity
//        animGroup.autoreverses = false
//        animGroup.isRemovedOnCompletion = false
//        
//        layer.add(animGroup, forKey: "skeleton_animation")
    }
    
    func dismiss() {
        isHidden = true
        layer.removeAllAnimations()
    }
}

extension UIColor {
    func adjust(by percent: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * percent, alpha: a)
    }
}

extension CALayer {
    enum Constants {
        static let skeletonSubLayersName = "SkeletonSubLayersName"
    }
    
    var skeletonSublayers: [CALayer] {
        return sublayers?.filter { $0.name == Constants.skeletonSubLayersName } ?? [CALayer]()
    }
    
    @objc func tint(withColors colors: [UIColor], traitCollection: UITraitCollection?) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            if #available(iOS 13.0, tvOS 13, *), let traitCollection = traitCollection {
                backgroundColor = colors.first?.resolvedColor(with: traitCollection).cgColor
            } else {
                backgroundColor = colors.first?.cgColor
            }
        }) {
            $0.tint(withColors: colors, traitCollection: traitCollection)
        }
    }
}
extension CAGradientLayer {
    
    
    override func tint(withColors colors: [UIColor], traitCollection: UITraitCollection?) {
        skeletonSublayers.recursiveSearch(leafBlock: {
            if #available(iOS 13.0, tvOS 13, *), let traitCollection = traitCollection {
                self.colors = colors.map { $0.resolvedColor(with: traitCollection).cgColor }
            } else {
                self.colors = colors.map { $0.cgColor }
            }
        }) {
            $0.tint(withColors: colors, traitCollection: traitCollection)
        }
    }
    
    
}

typealias VoidBlock = () -> Void
typealias RecursiveBlock<T> = (T) -> Void

protocol IterableElement {}
extension UIView: IterableElement {}
extension CALayer: IterableElement {}

// MARK: Recursive
protocol Recursive {
    associatedtype Element: IterableElement
    func recursiveSearch(leafBlock: VoidBlock, recursiveBlock: RecursiveBlock<Element>)
}

extension Array: Recursive where Element: IterableElement {
    func recursiveSearch(leafBlock: VoidBlock, recursiveBlock: RecursiveBlock<Element>) {
        guard !isEmpty else {
            leafBlock()
            return
        }
        forEach { recursiveBlock($0) }
    }
}
