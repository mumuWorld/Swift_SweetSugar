//
//  UIDevice+Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/27.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import UIKit

public let kScreenWidth = UIScreen.main.bounds.size.width
public let kScreenHeigh = UIScreen.main.bounds.size.height

extension UIDevice {
    
    public var isIPad: Bool {
        return (model == "iPad")
    }
    
    public var ydt_isIpad: Bool {
        return UIDevice.current.isIPad
    }

    /// 是否是分屏模式: 不相等就是分屏
    public func ydt_isSlideModel(transitionSize size: CGSize = .zero) -> Bool {
        guard ydt_isIpad else { return false }
        if size.equalTo(.zero) {
            return ydt_screenWidth != ydt_fabScreenWidth
        }
        return size.width != kScreenWidth && size.width != kScreenHeigh
    }
    /// 处理ipad 并且不分屏的情况
    public var  ydt_handleIpad: Bool {
        return ydt_isIpad && ydt_screenWidth == min(kScreenWidth, kScreenHeigh)
    }

    public var kWindowWidth: CGFloat {
        UIApplication.shared.delegate?.window??.bounds.size.width ?? kScreenWidth
    }
    public var kWindowHeight: CGFloat {
        UIApplication.shared.delegate?.window??.bounds.size.height ?? kScreenHeigh
    }

    public var ydt_screenWidth: CGFloat {
        return min(kWindowWidth, kWindowHeight)
    }

    public var ydt_screenHeight: CGFloat {
        return max(kWindowWidth, kWindowHeight)
    }

    public var ydt_curScreenHeight: CGFloat {
        //ipad 横屏
        if UIDevice.current.isIPad, UIWindow.isLandscape {
          return min(kScreenWidth, kScreenHeigh)
        }
        return max(kScreenWidth, kScreenHeigh)
    }

    public var ydt_curScreenWidth: CGFloat {
        //ipad 横屏
        if UIDevice.current.isIPad, UIWindow.isLandscape {
          return max(kWindowWidth, kWindowHeight)
        }
        return min(kWindowWidth, kWindowHeight)
    }

    public var ydt_ipadScreenWidth: CGFloat {
        return ydt_isIpad ? ceil(ydt_screenWidth * 0.8) : ydt_screenWidth
    }

    public var ydt_fabScreenWidth: CGFloat {
        return min(kScreenWidth, kScreenHeigh)
    }

    public var ydt_fabScreenHeight: CGFloat {
        return min(kScreenWidth, kScreenHeigh)
    }

    public var ydt_fabIpadScreenWidth: CGFloat {
        return ydt_isIpad ? ceil(ydt_fabScreenWidth * 0.8) : ydt_fabScreenWidth
    }
    
    public var ydt_nowScreenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    public var ydt_nowScreenHeight: CGFloat {
        return UIScreen.main.bounds.size.height
    }
}

public extension UIWindow {
    
    /// 是否横屏
    static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                .first?
                .windowScene?
                .interfaceOrientation
                .isLandscape ?? false
        } else {
            return UIApplication.shared.statusBarOrientation.isLandscape
        }
    }
}
