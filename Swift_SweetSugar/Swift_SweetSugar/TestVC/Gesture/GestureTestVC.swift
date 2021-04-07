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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let long = UILongPressGestureRecognizer(target: self, action: #selector(handleGes(sender:)))
        touchView.addGestureRecognizer(long)
        long.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGes(sender:)))
        touchView.addGestureRecognizer(tap)
        
        touchView.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    
    @objc func handleGes(sender: UILongPressGestureRecognizer) {
        mm_printLog("state->\(sender.state.rawValue)")
    }
    @objc func handleTapGes(sender: UITapGestureRecognizer) {
        mm_printLog("state->\(sender.state.rawValue)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GestureTestVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        mm_printLog("should->\(gestureRecognizer.state.rawValue)")
        return true
    }
}
