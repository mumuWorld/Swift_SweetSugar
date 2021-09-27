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
        // Do any additional setup after loading the view.
    }
}

extension MMIpadController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        mm_printLog(size)
        //原始
        mm_printLog("k->\(kScreenWidth), ->\(kScreenHeigh), ydt_nowScreenWidth ->\(UIDevice.current.ydt_nowScreenWidth), -> \(UIDevice.current.ydt_nowScreenHeight)")
        mm_printLog("window->\(UIDevice.current.kWindowWidth), ->\(UIDevice.current.kWindowHeight)")
    }
}
