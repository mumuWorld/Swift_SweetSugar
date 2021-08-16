//
//  MMEmitterVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/7/13.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMEmitterVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let emitter = create()
        MMDispatchTimer.createOnceTimer(afterTime: 2) {
            UIView.animate(withDuration: 1) {
                emitter.opacity = 0
            } completion: { _ in
                emitter.removeFromSuperlayer()
            }
        }
    }
    
    func create() -> CAEmitterLayer {
        // 1.创建发射器
        let emitter = CAEmitterLayer()
//        guard let emitter = self.emitter else { return }
        // 2.发射器位置
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width * 0.5, y:  view.mm_width * 0.5)
        // 发射器size
        emitter.emitterSize = CGSize(width: 20, height: 20)
        // 3.开启三维效果
        emitter.preservesDepth = true
        // 发射器深度 依赖于 emitterShape
        emitter.emitterDepth = 0.0
        // `point' (the default), `line', `rectangle' 矩形, `circle', `cuboid'长方体 and `sphere'.
        // 发射源的形状
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        // 4.设置 Cell(对应其中一个粒子)
        // 4.0.创建粒子
        let cell = CAEmitterCell()
        // 4.1.每秒发射粒子数
        cell.birthRate = 3
        // 4.2.粒子存活时间
        cell.lifetime = 5
        cell.lifetimeRange = 2.5
        // 4.3.缩放比例
        cell.scale = 0.7
        cell.scaleRange = 0.3
        // 4.4.粒子发射方向
        cell.emissionLongitude = CGFloat.pi * 0.5
        cell.emissionRange = CGFloat.pi * 0.25
        // 4.5.粒子初始速度
        cell.velocity = 150
        cell.velocityRange = 50
        // 4.6.旋转速度
        cell.spin = CGFloat.pi * 0.5
        cell.spinRange = CGFloat.pi * 0.25
        // 4.7.粒子内容
        cell.contents = UIImage(named: "carrot6")?.cgImage
        // 5.将粒子添加到发射器中
        emitter.emitterCells = [cell]
        view.layer.addSublayer(emitter)
        return emitter
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
