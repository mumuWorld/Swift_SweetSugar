//
//  GradientRingView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/6/20.
//  Copyright © 2024 Mumu. All rights reserved.
//

import UIKit

class GradientRingView: UIView {
    
    var lineWidth: Double = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupGradientRing()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setupGradientRing()
    }
    
    private func setupGradientRing() {
        // 设置圆环路径
//        let circlePath = UIBezierPath(
//            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
//            radius: bounds.width / 2 - 10,
//            startAngle: -CGFloat.pi / 2,
//            endAngle: 1.5 * CGFloat.pi,
//            clockwise: true
//        )
        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        // 不能贴着bounds画要把线宽留出来
        let rect = bounds.inset(by: UIEdgeInsets(top: lineWidth, left: lineWidth, bottom: lineWidth, right: lineWidth))
        let roundedRectPath = UIBezierPath(roundedRect: rect, cornerRadius: 50)

        
        // 创建圆环形状层
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = roundedRectPath.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        
        // 创建第一个渐变层
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer1.frame = bounds
        let angle = CGFloat.pi / 5
        let transform = CGAffineTransform(rotationAngle: angle)
        gradientLayer1.setAffineTransform(transform)
        
        
        // 创建第二个渐变层
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.colors = [UIColor.blue.cgColor, UIColor.green.cgColor]
        gradientLayer2.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer2.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer2.frame = bounds
        gradientLayer2.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        gradientLayer2.opacity = 0.5
        
        // 创建容器层以组合渐变层
        let gradientContainerLayer = CALayer()
        gradientContainerLayer.addSublayer(gradientLayer1)
//        gradientContainerLayer.addSublayer(gradientLayer2)
//        gradientContainerLayer.mask = shapeLayer
        
        // 创建阴影形状层
        let shadowShapeLayer = CAShapeLayer()
        shadowShapeLayer.path = roundedRectPath.cgPath
        shadowShapeLayer.lineWidth = lineWidth
        shadowShapeLayer.fillColor = UIColor.clear.cgColor
        shadowShapeLayer.strokeColor = UIColor.red.cgColor
        shadowShapeLayer.shadowColor = UIColor.black.cgColor
        shadowShapeLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowShapeLayer.shadowRadius = 5
        shadowShapeLayer.shadowOpacity = 0.9
        
        // 创建渐变阴影层
        let shadowGradientLayer = CAGradientLayer()
        shadowGradientLayer.colors = [UIColor.blue.cgColor, UIColor.red.cgColor]
        shadowGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        shadowGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        shadowGradientLayer.frame = bounds
        
        // 将渐变阴影层添加到阴影形状层
        let shadowContainerLayer = CALayer()
        shadowContainerLayer.addSublayer(shadowGradientLayer)
        shadowContainerLayer.mask = shadowShapeLayer
        
        // 添加阴影层到视图层次中
//        layer.addSublayer(shadowContainerLayer)
        
        // 将容器层添加到视图的层中
        layer.addSublayer(gradientContainerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupGradientRing()
    }
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        
//        
//    }
}
