//
//  UIColor+MM_Extension.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/7/2.
//  Copyright © 2019 Mumu. All rights reserved.
//

import UIKit

extension UIColor {
    class func mm_randomColor() -> UIColor {
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// hex 颜色
    ///
    /// - Parameters:
    ///   - color_vaule: 16位颜色
    ///   - alpha: 默认 1
    class func mm_colorFromHex(color_vaule : UInt64 , alpha : CGFloat = 1) -> UIColor {
        let redValue = CGFloat((color_vaule & 0xFF0000) >> 16)/255.0
        let greenValue = CGFloat((color_vaule & 0xFF00) >> 8)/255.0
        let blueValue = CGFloat(color_vaule & 0xFF)/255.0
        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
    
    /// hex string颜色
    ///
    /// - Parameters:
    ///   - color_vaule: 16位颜色
    ///   - alpha: 默认 1
    class func mm_colorFromHexString(color_vaule : String , alpha : CGFloat = 1) -> UIColor {
        
        if color_vaule.isEmpty {
            return UIColor.clear
        }
        
        var cString = color_vaule.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count == 0 {
            return UIColor.clear
        }
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count < 6 && cString.count != 6 {
            
            return UIColor.clear
        }
        let value = "0x\(cString)"
        let scanner = Scanner(string:value)
        var hexValue : UInt64 = 0
        //查找16进制是否存在
        if scanner.scanHexInt64(&hexValue) {
            print(hexValue)
            let redValue = CGFloat((hexValue & 0xFF0000) >> 16)/255.0
            let greenValue = CGFloat((hexValue & 0xFF00) >> 8)/255.0
            let blueValue = CGFloat(hexValue & 0xFF)/255.0
            return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
        }else{
            return UIColor.clear
        }
    }
}
