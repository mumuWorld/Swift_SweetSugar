//
//  MMSplashViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/5/24.
//  Copyright © 2024 Mumu. All rights reserved.
//

import UIKit
import CoreMotion

class MMSplashViewController: UIViewController {

    lazy var motionManager: CMMotionManager = {
        let m = CMMotionManager.init()
        m.accelerometerUpdateInterval = 0.1
        return m
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        motionManager.startAccelerometerUpdates(to: OperationQueue()) { [weak self] data, error in
//            guard let self = self else { return }
//            print("test->crash:回调: \(Thread.current)")
//            self.motionManager.stopAccelerometerUpdates()
//
//            DispatchQueue.main.async {
//                print("test->主线程回到: \(self)")
//            }
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                print("test->主线程回到:2 \(self)")
//            }
//        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        motionManager.stopAccelerometerUpdates()
        print("test->viewDidDisappear:")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("test->viewDidAppear:")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("test->发送通知: \(self)")
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "dismissVC")))
        }
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
