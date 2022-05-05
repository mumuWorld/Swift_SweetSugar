//
//  UIButton+typeLayout.swift
//  RZParent
//
//  Created by lijiantao on 2019/11/22.
//  Copyright © 2019 李建涛. All rights reserved.
//
import UIKit

enum MMBtnImageLayoutStyle {
    case Top//image在上，label在下
    case Left//image在左,label在右
    case Bottom//image在下，label在上
    case Right//image在右,label在左
};


extension UIButton {
    
    func mm_layoutImgStyle(style:MMBtnImageLayoutStyle, space:CGFloat) {
        
        //1、得到imageView和titleLabel的宽、高
        let imageWidth = imageView?.frame.size.width
        let imageHeight = imageView?.frame.size.height
        
        var labelWidth : CGFloat = 0.0
        var labelHeight : CGFloat = 0.0
        
        if #available(iOS 8.0, *) {
            
            //由于iOS8中titleLabel的size为0，分开设置
            labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
            labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        } else {
            labelWidth = (self.titleLabel?.frame.size.width)!
            labelHeight = (self.titleLabel?.frame.size.height)!
        }
        
        //2、声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        

        //3、根据style和space设置
        switch (style) {
        case .Top:
            imageEdgeInsets = UIEdgeInsets.init(top: -labelHeight-space/2.0, left: 0, bottom: 0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageWidth!, bottom: -imageHeight!-space/2.0, right: 0)
            break;
        case .Left:
            imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -space/2.0, bottom: 0, right: space/2.0);
            labelEdgeInsets = UIEdgeInsets.init(top: 0, left: space/2.0, bottom: 0, right: space/2.0)
            break
        case .Bottom:
            imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: -labelHeight-space/2.0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets.init(top: -labelHeight-space/2.0, left: 0, bottom: -imageWidth!, right: 0)
            break
        case .Right:
            imageEdgeInsets = UIEdgeInsets.init(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageWidth! - space/2.0, bottom: 0, right: imageWidth!+space/2.0)
            break
            
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
    
    func cleanButtonWithEdgeInsetsStyle() {
        
        self.titleEdgeInsets = UIEdgeInsets.zero
        self.imageEdgeInsets = UIEdgeInsets.zero
        
    }
    
}

