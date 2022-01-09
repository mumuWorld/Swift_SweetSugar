//
//  MMCurveView.swift
//  Swift_SweetSugar
//
//  Created by Mumu on 2022/1/9.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit


class MMCurveView: UIView {
    /// 最大point数量
    let pointCount: Int = 6
    /// point基础y值
    let base_y: CGFloat = 30

    var _highNumbers: [Int] = []
    var _lowNumbers: [Int] = []
    
    var _highLabels: [UILabel] = []
    var _lowLabels: [UILabel] = []
    
    var maxNumber: Int = 0
    var numberDistance: Int = 0

    lazy var tmL: UILabel = {
        let item = UILabel()
        item.text = "14°"
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tmL)
        for i in 0..<pointCount {
            let h_label = UILabel()
            let l_label = UILabel()
            if i == 0 {
                h_label.textColor = UIColor.black.withAlphaComponent(0.5)
                l_label.textColor = UIColor.black.withAlphaComponent(0.5)
            } else {
                h_label.textColor = UIColor.black
                l_label.textColor = UIColor.black
            }
            h_label.font = UIFont.systemFont(ofSize: 14)
            l_label.font = UIFont.systemFont(ofSize: 14)
            _highLabels.append(h_label)
            _lowLabels.append(l_label)
            addSubview(h_label)
            addSubview(l_label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(highNumbers: [Int], lowNumbers: [Int]) {
        //设置label文字
        _highNumbers = highNumbers
        _lowNumbers = lowNumbers
        findMiddleNumber()
        setNeedsDisplay()
    }
    
    func findMiddleNumber() {
        var max_h = -100
        var min_l = 100
        for (i, high) in _highNumbers.enumerated() {
            max_h = max(max_h, high)
            min_l = min(min_l, _lowNumbers[i])
        }
        numberDistance = max_h - min_l
        maxNumber = max_h
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(), _highNumbers.count == pointCount, _highNumbers.count == _lowNumbers.count else {
            return
        }
        //绘制背景颜色
//        context.setFillColor(UIColor.yellow.withAlphaComponent(0.4).cgColor)
//        context.addRect(rect)
//        context.fillPath()
        //安全高度 = 最大高度 - 上下两个温度lable的高度 - 最高点和最低点的间隙10
        let safeHeight = rect.height - 40 - 10
        //一度有多高
        let per_h = safeHeight / CGFloat(numberDistance)
        //每个point 宽度
        let per_w = floor(rect.width / CGFloat(pointCount))
        
        
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setLineWidth(2)
        
        let highPath = UIBezierPath()
        drawPath(isHigh: true, per_w: per_w, per_h: per_h, path: highPath, numbers: _highNumbers, labels: _highLabels)
        context.addPath(highPath.cgPath)
        context.setStrokeColor(UIColor.red.cgColor)
        context.strokePath()
        
        let lowPath = UIBezierPath()
        drawPath(isHigh: false, per_w: per_w, per_h: per_h, path: lowPath, numbers: _lowNumbers, labels: _lowLabels)
        context.addPath(lowPath.cgPath)
        context.setStrokeColor(UIColor.blue.cgColor)
        context.strokePath()
    }
    
    func drawPath(isHigh: Bool, per_w: CGFloat, per_h: CGFloat, path: UIBezierPath, numbers: [Int], labels: [UILabel]) {
        //point开始x
        let start_x = per_w * 0.5
        //计算point 的x，y ， 并且给label赋值和定位
        var xList: [CGFloat] = []
        var yList: [CGFloat] = []
        for i in 0..<pointCount {
            let point_x = start_x + CGFloat(i) * per_w
            xList.append(point_x)
            let number_h = numbers[i]
            let h_dis = CGFloat(maxNumber - number_h)
            let point_h_y = h_dis * per_h + base_y
            yList.append(point_h_y)
            let label = labels[i]
            label.text = String(format: "%i°", number_h)
            label.sizeToFit()
            label.center = CGPoint(x: point_x, y: isHigh ? point_h_y - 10 : point_h_y + 10)
        }
        //开始构建曲线
        path.move(to: CGPoint(x: xList[0], y: yList[0]))
        for i in 0..<(pointCount - 1) {
            let point_x = xList[i]
            let point_next_x = xList[i + 1]

            let point_y = yList[i]
            let point_next_y = yList[i + 1]
            // 控制点的横坐标都是一样的：取两点横坐标的平均值，纵坐标不同：控制点1的纵坐标是当前点的纵坐标，控制点2的纵坐标是下一个点的纵坐标。
            let controlPoint_x = (point_x + point_next_x) / 2
            let controlPoint1 = CGPoint(x: controlPoint_x, y: point_y)
            let controlPoint2 = CGPoint(x: controlPoint_x, y: point_next_y)
            
            path.addCurve(to: CGPoint(x: point_next_x, y: point_next_y), controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
    }
}
