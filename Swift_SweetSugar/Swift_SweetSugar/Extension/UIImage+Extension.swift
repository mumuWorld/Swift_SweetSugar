//
//  UIImage+Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/7/13.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// 根据当前layer生成图片
    /// - Parameter layer: layer
    /// - Returns: 图片
    class func createLayerImg(layer: CALayer) -> UIImage? {
        let size = layer.frame.size
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func createImage(_ color: UIColor = .red) -> UIImage {
        let rect = CGRect(x:0,y:0,width:1,height:1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!

    }
}
