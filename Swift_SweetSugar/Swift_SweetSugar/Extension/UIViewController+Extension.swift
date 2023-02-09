//
//  UIViewController+Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/1/3.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

extension UIViewController {
    class func currentViewController() -> UIViewController? {
        guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController ?? UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        return currentViewController(base: rootVC)
    }
    
    class func currentViewController(base: UIViewController?) -> UIViewController? {
        guard let base = base else {
            return nil
        }
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let lastChild = base.children.last, lastChild is UINavigationController {
            return currentViewController(base: lastChild)
        }
        if let presented = base.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}
