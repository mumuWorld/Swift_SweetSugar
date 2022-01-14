//
//  MMSunMoonView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/14.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import UIKit

class MMSunMoonView: UIView {
    
    var sunImgV: UIImageView = UIImageView(image: UIImage(named: "light"))
    var moonImgV: UIImageView = UIImageView(image: UIImage(named: "light"))

    var lineWidth: CGFloat = 1
    var lineColor: UIColor = .red
    /// 线段长度
    var leftNumber: CGFloat = 3
    /// 线段间距
    var rightNumber: CGFloat = 3
    
    var sPath: UIBezierPath?
    
    var mPath: UIBezierPath?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), rect.width > 0, rect.height > 0 else { return }
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        //设置虚线参数
        let lengths: [CGFloat] = [leftNumber, rightNumber]
        context.setLineDash(phase: lineWidth, lengths: lengths)
        //太阳半径
        let (s_r, m_r, s_start, m_start, s_end, m_end) = calculate(rect: rect)
        //外圈需要考虑线宽
        let fitLines = lineWidth * 0.5
        let _sPath = UIBezierPath(arcCenter: CGPoint(x: rect.width * 0.5, y: s_r + fitLines), radius: s_r - fitLines, startAngle: s_start, endAngle: s_end, clockwise: true)
        context.addPath(_sPath.cgPath)
        context.strokePath()
        sPath = _sPath
        //内圈
        context.setStrokeColor(UIColor.green.cgColor)
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.width * 0.5, y: s_r), radius: m_r, startAngle: m_start, endAngle: m_end, clockwise: true)
        context.addPath(path.cgPath)
        context.strokePath()
        
        showAnimation()
    }
    
    /*
     x^2 = (R^2 - (w/2)^2)
     R = x + h
     x = ((w/2)^2 - h^2) / (2 * h)
     */
    /// 计算半径，开始和结束弧度
    func calculate(rect: CGRect) -> (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) {
        //计算半径 和 高度差 x
        let w = rect.width / 2
        let h = rect.height
        let x = (w * w - h * h) / (2 * h)
        let r = x + h
        let m_r = r - 20
        
        //弧度, 反正弦直接就是弧度了。没必要再计算
        let s_min_angle =  acos(w / r)
        let m_min_angle =  asin(x / m_r)
        
        let s_start_ang = -Double.pi + s_min_angle
        let m_start_ang = -Double.pi + m_min_angle
        
        let s_end_ang = -s_min_angle
        let m_end_ang = -m_min_angle
        
        return (r, m_r, s_start_ang, m_start_ang, s_end_ang, m_end_ang)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sunImgV)
        sunImgV.mm_size = CGSize(20, 20)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(sunImgV)
        sunImgV.mm_size = CGSize(20, 20)
    }
    
    func showAnimation() -> Void {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = sPath?.cgPath
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.duration = 3.0
        animation.calculationMode = .paced
        sunImgV.layer.add(animation, forKey: "s_show")
    }
}
