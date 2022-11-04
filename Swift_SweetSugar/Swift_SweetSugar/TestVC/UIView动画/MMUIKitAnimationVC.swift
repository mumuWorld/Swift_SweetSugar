//
//  MMUIKitAnimationVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/7/4.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class MMUIKitAnimationVC: UIViewController {
    //蓝色在最底层
    @IBOutlet weak var view1: UIView!
    //棕色，在view1上面
    @IBOutlet weak var view2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func clickType(_ sender: UIButton) {
//        if view2.superview == nil {
//            view.insertSubview(view2, aboveSubview: view1)
//        }
        var type : UIView.AnimationOptions?
        if sender.tag == 1 {
            type = .transitionFlipFromBottom
        }
        if let _type = type {
            //transitionCurlUp 翻页 ，移除view2. 并且view2 == nil
            UIView.transition(from: view2, to: view1, duration: 1, options: [.curveEaseIn, _type])
        } else {
            //transitionCurlUp 翻页 ，移除view2.  并且view2 == nil
            UIView.transition(from: view2, to: view1, duration: 1, options: [.curveEaseIn])
        }
        //把view1放在最下面
        view.sendSubviewToBack(view1)
    }


}
