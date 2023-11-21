//
//  MMDefine.swift
//  Swift_SweetSugar
//
//  Created by Mumu on 2022/4/3.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

let kNaviBarContentHeight: CGFloat = 44.0

public var kNaviBarHeight: CGFloat {
    if #available(iOS 11, *) {
        guard let insets = UIApplication.shared.delegate?.window??.safeAreaInsets else { return 64 }
        return insets.top + kNaviBarContentHeight
    } else {
        return 64
    }
}
// 34
public let kBottomSafeHeight: CGFloat = {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    } else {
        return 0.0
    }
}()

/// 推荐使用 kTopSafeHeight 此处命名与实际语义不同， 按照现有用法，先暂时保留此变量
public let kStatusBarHeight: CGFloat = {
    if #available(iOS 11.0, *) {
        let height = UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 20
        if height > 20 {
            return height
        } else {
            return 20
        }
    } else {
        return 20
    }
}()
