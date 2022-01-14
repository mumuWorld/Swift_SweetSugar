//
//  MMPieChartView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/7/12.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import UIKit

class MMPieChartView: UIView {
    
    var percents: [CGFloat] = []
    
    var colors: [UIColor] = []
    
    var bgColor: UIColor = .clear
    
    var drawWidth: CGFloat = 0
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), !percents.isEmpty ,percents.count == colors.count else {
            return
        }
        //绘制背景颜色
        context.setFillColor(bgColor.cgColor)
        context.addRect(rect)
        context.fillPath()
        
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        //调整绘画宽度 当线宽大于 宽度一半，就是饼图了。
        let fitWidth = min(rect.width * 0.5, drawWidth)
        let radius = (rect.width - fitWidth) * 0.5
        context.setLineWidth(fitWidth)
        //开始角度
        var lastAngle = -CGFloat.pi * 0.5
        
        for (index, item) in percents.enumerated() {
            let color = colors[index]
            //结算结束角度
            let endAngle = lastAngle + item * CGFloat.pi * 2
            let anglePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: lastAngle, endAngle: endAngle, clockwise: true)
            lastAngle = endAngle
            
            context.setStrokeColor(color.cgColor)
            context.addPath(anglePath.cgPath)
            context.strokePath()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
}
