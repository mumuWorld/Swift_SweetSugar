//
//  MMLayerAnimationVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/22.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMLayerAnimationVC: UIViewController {

    @IBOutlet weak var view_1: UIView!
    
    @IBOutlet weak var view_2: UIView!
    
    @IBOutlet weak var view_3: UIView!
    
    @IBOutlet weak var animationImgView: UIImageView!
    
    @IBOutlet weak var searchIconImgView: UIImageView!
    
    lazy var entryView: YDDOCRKeyInfoEntryView = {
        let item = YDDOCRKeyInfoEntryView()
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate
        // Do any additional setup after loading the view.
        animationImgView.backgroundColor = .blue
        view.addSubview(entryView)
        entryView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-200)
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        test_transform_x()
//        createMask()
//        groupTest()
//        entryView.show()
//        trans()
        yinshidonghua()
    }
    
    /// 隐式动画
    func yinshidonghua() {
        // 都没有动画
        view_1.backgroundColor = .red
        view_3.layer.backgroundColor = UIColor.green.cgColor
    }
    
    func groupTest() {
        view_1.layer.removeAllAnimations()
        let trans = CGAffineTransform.identity
        
        var toTrans = CGAffineTransform(scaleX: 1.3, y: 1)
        toTrans = toTrans.translatedBy(x: 0, y: 20)
        
        let base = CABasicAnimation(keyPath: "transform.translation.y")
        //延迟0.1秒执行
//        base.beginTime = CACurrentMediaTime() + 0.1
        base.fromValue = 0
        base.toValue = -50
        base.duration = 3
        
        let baseWidth = CABasicAnimation(keyPath: "opacity")
//        //延迟0.1秒执行
        baseWidth.beginTime = CACurrentMediaTime() + 0.1
        baseWidth.fromValue = 0.1
        baseWidth.toValue = 1
        baseWidth.duration = 6
        
        let group = CAAnimationGroup()
        group.duration = 3
        group.animations = [base, baseWidth]
        group.delegate = self
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        
//        view_1.layer.add(base, forKey: nil)
//        view_1.layer.add(baseWidth, forKey: nil)

        view_1.layer.add(group, forKey: nil)
    }
    
    func trans() -> Void {
        // 要先设置m34 再设置旋转
        var form = CATransform3DIdentity
        form.m34 = -1.0 / 1000
        form = CATransform3DRotate(form, CGFloat(Double.pi * 0.25), 0, 1, 0)
        
        let trans = CABasicAnimation(keyPath: "transform")
        trans.fromValue = CATransform3DIdentity
        trans.toValue = form
        trans.duration = 1.0
        trans.fillMode = .forwards
        trans.isRemovedOnCompletion = false
        searchIconImgView.layer.add(trans, forKey: "trans")
    }
    
    func createMask() {
        let img = UIImage(named: "mask")
        let layer = CAGradientLayer()
        layer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor, UIColor.green.cgColor]
        layer.contents = img?.cgImage
        layer.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        layer.opacity = 0.7
        
//        view_2.layer.mask = layer
        
        let image = UIImage.createLayerImg(layer: animationImgView.layer)
        animationImgView.image = image
        
        animationImgView.layer.mask = layer

        let transAni = createBaseAnimation(path: "transform.translation.x", from: 0, to: ScreenWidth)
        layer.add(transAni, forKey: "test")
//        view_2.layer.addSublayer(layer)
    }

    func test1() -> Void {
        var frame = view_1.layer.bounds
//        frame.size.width = 200
        frame.size.height = 60
        //改变bounds的坐标，影响的是子视图的位置。50 ，所以 子视图0,0 要对应减去 50 左移。
        frame.origin.x = 50
//        frame.origin.y = 104
        //bound->(10.0, 104.0, 100.0, 50.0),(0.0, 0.0, 100.0, 50.0), (10.0, 104.0, 100.0, 50.0)
        mm_printLog("bound->\(view_1.frame),\(view_1.layer.bounds), \(view_1.layer.frame)")
        let base = CABasicAnimation(keyPath: "bounds")
        base.fromValue = view_1.layer.bounds
        base.toValue = frame
        base.duration = 2.0
        base.fillMode = .forwards
        base.isRemovedOnCompletion = false
        view_1.layer.add(base, forKey: "test_base")
    }
    
    func test_1subBounds() -> Void {
        //有效
        let base = CABasicAnimation(keyPath: "bounds.size.width")
        base.fromValue = 100
        base.toValue = 200
        base.duration = 2.0
        base.fillMode = .forwards
        base.isRemovedOnCompletion = false
        view_1.layer.add(base, forKey: "test_base")
    }
    
    func test_postionZ() -> Void {
        //有效
        createAnimation(path: "zPosition", from: 0, to: 1000)
//        let trans = CATransform3DMakeScale(<#T##sx: CGFloat##CGFloat#>, <#T##sy: CGFloat##CGFloat#>, <#T##sz: CGFloat##CGFloat#>)
//        CATransform3DMakeRotation(<#T##angle: CGFloat##CGFloat#>, <#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##z: CGFloat##CGFloat#>)
    }
    
    func test_transform_x() {
        //有效
        createAnimation(path: "transform.scale.x", from: 1, to: 0.1, by: 0.5)
    }
    
    func createAnimation(path: String, from: Any, to: Any) -> Void {
        //有效
        let base = CABasicAnimation(keyPath: path)
        base.fromValue = from
        base.toValue = to
        base.duration = 2.0
        base.fillMode = .forwards
        base.isRemovedOnCompletion = false
        view_1.layer.add(base, forKey: "test_base")
    }
    
    func createBaseAnimation(path: String, from: Any, to: Any) -> CABasicAnimation {
        //有效
        let base = CABasicAnimation(keyPath: path)
        base.fromValue = from
        base.toValue = to
        base.duration = 3.0
        base.fillMode = .forwards
        base.isRemovedOnCompletion = false
//        base.repeatCount = Float.infinity
        return base
    }
    
    ///  1 代表有值 0 为 0
    /// from 1 to 1 by 1 = from -> to
    /// from 1 to 0 by 1 =  from ->  from + to
    /// from 0 to 1 by 1 = min(to, by) -> to
    func createAnimation(path: String, from: Any, to: Any, by: Any) -> Void {
        //有效
        let base = CABasicAnimation(keyPath: path)
        base.fromValue = from
        base.toValue = to
        base.byValue = by
        base.duration = 2.0
        base.fillMode = .removed
        base.isRemovedOnCompletion = false
        view_1.layer.add(base, forKey: "test_base")
    }
}

extension MMLayerAnimationVC: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        mm_printLog("start->\(anim)")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        mm_printLog("Stop->\(anim)")
    }
}
