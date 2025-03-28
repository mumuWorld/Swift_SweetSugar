//
//  MMBaseNavigationController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/3.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMBaseNavigationController: UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        delegate = self
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return topViewController?.preferredStatusBarStyle ?? .default
//    }
    
    open var isInteracitvePopEnable = true
    
    
}

extension MMBaseNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIScreenEdgePanGestureRecognizer {
            if self.viewControllers.count <= 1 {
                return false
            }
        }
        return isInteracitvePopEnable
    }
}

extension MMBaseNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        if  viewControllers.count > 1 {
//            viewController.hidesBottomBarWhenPushed = true
//        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
