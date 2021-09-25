//
//  MMGraphic2VC.swift
//  Swift_SweetSugar
//
//  Created by Mumu on 2021/9/25.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
class Canvas: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(10)
        //butt 尖嘴
        context.setLineCap(.butt)
        
        lines.forEach { line in
            for (i, point) in line.enumerated() {
                if i == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
        }
        
        context.strokePath()
    }
    
    lazy var lines: [[CGPoint]] = []
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.randomElement()?.location(in: nil) else { return }
        guard var line = lines.popLast() else {
            return
        }
        line.append(point)
        lines.append(line)
        setNeedsDisplay()
    }
}

class MMGraphic2VC: UIViewController {

    let canvas: Canvas = Canvas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(canvas)
        canvas.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
