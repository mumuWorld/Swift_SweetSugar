//
//  MMIpadController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/27.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMIpadController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("test-> isTrue: \(0 < 0)")
        let  result = calculateScaleValue(for: 60) {
            return (28, 19)
        }
        print("test->result: \(result)")
    }
    
    func calculateScaleValue(for height: Double, param:() -> (maxV: Double, minV: Double)) -> Double {
        let source = param()
        let y1 = 120.0
        let maxV = source.maxV
        let y2 = 80.0
        let minV = source.minV
        
        // 计算 x 的值
        let result = maxV + (minV - maxV) * ((height - y1) / (y2 - y1))
        // 防止小于minV
        return max(floor(result), minV)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("test->布局更新:k->\(kScreenWidth), ->\(kScreenHeigh), ydt_nowScreenWidth ->\(UIDevice.current.ydt_nowScreenWidth), -> \(UIDevice.current.ydt_nowScreenHeight)")
        mm_printLog("window->\(UIDevice.current.kWindowWidth), ->\(UIDevice.current.kWindowHeight)")
        
        let windowWidth = UIDevice.current.kWindowWidth
        let screentWidth = UIDevice.current.ydt_nowScreenWidth
        if windowWidth < screentWidth {
            
            let percent = windowWidth / screentWidth
            print("test->比例: \(percent)")
            if UIWindow.isLandscape {
                if percent > 0.5 { // 0.6601941747572816, 0.49558693733451015, 0.3309  , 0.43, 0.55
                    print("test-> 三分之二:")

                } else if percent > 0.4 {
                    print("test-> 一半")

                } else {  // 1/3
                    print("test-> 三分之一:")
                }
            } else { // 竖屏状态没有 1/2 的情况
                if percent > 0.5 {  // 2/3
                    print("test-> 三分之二:")
                } else { // 1/3
                    print("test-> 三分之一:")
                }
            }
            
        } else {
            // 无分屏
            print("test-> 未分屏")
        }
    }
    
    func showAlert() {
        let alert = UIAlertController.init(title: nil, message: "测试message", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "tit_1", style: .default, handler: { _ in
            mm_printLog("111")
        }))
        alert.addAction(UIAlertAction(title: "tit_2", style: .cancel, handler: { _ in
            mm_printLog("222")
        }))
        alert.addAction(UIAlertAction(title: "tit_3", style: .destructive, handler: { _ in
            mm_printLog("tit_3")
        }))
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = CGRect(x: 10, y: 10, width: 200, height: 200)
        present(alert, animated: true, completion: nil)
    }
}

extension MMIpadController {
    
    /// 转屏、分屏
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mm_printLog(size)
        //原始
        mm_printLog("k->\(kScreenWidth), ->\(kScreenHeigh), ydt_nowScreenWidth ->\(UIDevice.current.ydt_nowScreenWidth), -> \(UIDevice.current.ydt_nowScreenHeight)")
        mm_printLog("window->\(UIDevice.current.kWindowWidth), ->\(UIDevice.current.kWindowHeight)")
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection else { return }
        print("test->之前的状态: \(previousTraitCollection.horizontalSizeClass), \(previousTraitCollection.verticalSizeClass), \(traitCollection.horizontalSizeClass), \(traitCollection.verticalSizeClass)")
        // 处理分屏状态的变化
        if traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass {
            if traitCollection.horizontalSizeClass == .compact {
                print("处于分屏状态")
            } else {
                print("不是分屏状态")
            }
        }
    }

}
