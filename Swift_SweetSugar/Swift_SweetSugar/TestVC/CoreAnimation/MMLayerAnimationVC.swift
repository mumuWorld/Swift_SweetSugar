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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.delegate
        // Do any additional setup after loading the view.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        test_transform_x()
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
        base.fillMode = .forwards
        base.isRemovedOnCompletion = false
        view_1.layer.add(base, forKey: "test_base")
    }
}
