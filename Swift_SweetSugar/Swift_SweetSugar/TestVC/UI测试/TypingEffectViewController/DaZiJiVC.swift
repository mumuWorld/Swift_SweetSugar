//
//  DaZiJiVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/12/10.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation
import UIKit

class TypingEffectViewController: UIViewController {
    
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    private let fullText = "这是一个打字机效果的实现示例，文字逐步显示，并带有透明度渐变。"
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 添加 Label 到视图
        displayLabel.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 200)
        view.addSubview(displayLabel)
        
        // 开始打字机动画
        startTypingAnimation()
    }
    
    private func startTypingAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.currentIndex < self.fullText.count {
                let nextCharacter = self.fullText[self.fullText.index(self.fullText.startIndex, offsetBy: self.currentIndex)]
                self.appendCharacter(String(nextCharacter))
                self.currentIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func appendCharacter(_ character: String) {
        displayLabel.text = (displayLabel.text ?? "") + character
        
        // 透明度动画
        let animationLabel = UILabel(frame: displayLabel.frame)
        animationLabel.text = character
        animationLabel.textColor = displayLabel.textColor
        animationLabel.font = displayLabel.font
        animationLabel.alpha = 0
        animationLabel.textAlignment = displayLabel.textAlignment
        view.addSubview(animationLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            animationLabel.alpha = 1
        }) { _ in
            animationLabel.removeFromSuperview()
        }
    }
}
