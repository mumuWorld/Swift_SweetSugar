//
//  UITestVC+Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/5/8.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

//MARK: - Transform 测试

extension UITestVC {
    
    /// 结论：transform 会改变frame
    func transformTest() {
        //绿色视图为对比图
        let greenView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        greenView.backgroundColor = UIColor.green
        view.insertSubview(greenView, belowSubview: shadowView)
        shadowView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        shadowView.backgroundColor = .red
        // frame -> trans
//        transformTest1()
        // frame -> trans -> frame
        transformTest2()
        // anchorPoint -> trans
//        transformTest3()
        
        mm_printLog("end: \(String(describing: shadowView)), bounds: \(shadowView.bounds)")
    }
    
    func transformTest1() {
        // transfrom scale回影响到 frame.origin
        shadowView.transform = CGAffineTransform(scaleX: 2, y: 2)
        // frame = (50 50; 200 200); transform = [2, 0, 0, 2, 0, 0];  bounds  (0.0, 0.0, 100.0, 100.0)
        mm_printLog("\(String(describing: shadowView)), bounds: \(shadowView.bounds)")
    }
    
    // 设置transfrom 之后再设置 frame
    func transformTest2() {
        shadowView.transform = CGAffineTransform(scaleX: 2, y: 2)
        //frame = (50 50; 200 200); transform = [2, 0, 0, 2, 0, 0];
        mm_printLog("\(String(describing: shadowView)), bounds: \(shadowView.bounds)")
        //改变transfrom之后再改变frame, 他的transform不影响之后frame的变化, 此时和完美遮盖绿色view。 但实际上bounds已经变为了 50.
        shadowView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        // frame = (100 100; 100 100); transform = [2, 0, 0, 2, 0, 0]; , bounds: (0.0, 0.0, 50.0, 50.0)
        mm_printLog("\(String(describing: shadowView)), bounds: \(shadowView.bounds)")
    }
    
    func transformTest4() {
        shadowView.transform = CGAffineTransform(scaleX: 2, y: 2)
        //frame = (50 50; 200 200); transform = [2, 0, 0, 2, 0, 0];
        mm_printLog("\(String(describing: shadowView)), bounds: \(shadowView.bounds)")
        //改变transfrom之后再改变frame, 他的transform不影响之后frame的变化, 此时和完美遮盖绿色view。 但实际上bounds已经变为了 50.
        shadowView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        // frame = (100 100; 100 100); transform = [2, 0, 0, 2, 0, 0]; , bounds: (0.0, 0.0, 50.0, 50.0)
        mm_printLog("\(String(describing: shadowView)), bounds: \(shadowView.bounds)")
        shadowView.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    func transformTest3() {
        // 锚点不会影响 center 和 layer的position, 只会影响 frame.origin
        // frame = (100 100; 100 100);
        mm_printLog("\(String(describing: shadowView)), bounds: \(shadowView.bounds)")
        shadowView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        shadowView.transform = CGAffineTransform(scaleX: 2, y: 2)
        // frame = (150 150; 200 200); transform = [2, 0, 0, 2, 0, 0];  bounds  (0.0, 0.0, 100.0, 100.0) center(150.0, 150.0)
        mm_printLog("\(String(describing: shadowView)), bounds: \(shadowView.bounds)")
    }
}
