//
//  UIImageView+Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/11/15.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView: UITraitEnvironment {
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
//            guard previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle else {
//                return
//            }
//            if traitCollection.userInterfaceStyle == .dark {
//                backgroundColor = .blue
//            } else {
//                backgroundColor = .red
//            }
        }
    }

}
