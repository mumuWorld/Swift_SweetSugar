//
//  GestureTestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/4/7.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class GestureTestVC: UIViewController {

    @IBOutlet weak var touchView: MMTouchView!
    
    @IBOutlet weak var controlView: MMControlView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let long = UILongPressGestureRecognizer(target: self, action: #selector(handleGes(sender:)))
//        touchView.addGestureRecognizer(long)
//        long.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGes(sender:)))
//        view.addGestureRecognizer(tap)
        touchView.addGestureRecognizer(tap)
        touchView.layer.cornerRadius = 15
        
        controlView.addTarget(self, action: #selector(handleControlClick(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        let tap_2 = UITapGestureRecognizer(target: self, action: #selector(handleTapGes(sender:)))
        view.addGestureRecognizer(tap_2)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        pan.delaysTouchesBegan = true
        view.addGestureRecognizer(pan)
    }
    
    @objc func handleGes(sender: UILongPressGestureRecognizer) {
        mm_printLog("state->\(sender.state)")
    }
    @objc func handleTapGes(sender: UITapGestureRecognizer) {
        mm_printLog("state->\(sender.state)")
    }

    @IBAction func handelBtnClick(_ sender: UIButton) {
        mm_printLog("handleClick->UIButton")
    }
    
    @IBAction func handleClick(_ sender: MMButton) {
        mm_printLog("handleClick->MMButton")
    }
    
    @objc func handleControlClick(_ sender: MMControlView) {
        mm_printLog("handleClick->MMControlView")
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        mm_printLog("pan_state->\(sender.state)")
    }
}

extension GestureTestVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        mm_printLog("should->\(gestureRecognizer.state.rawValue)")
        return true
    }
}
