//
//  MMCoreTextVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/27.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMCoreTextVC: UIViewController {

    lazy var textView: MMTextView = {
        let item = MMTextView()
        item.backgroundColor = UIColor.systemYellow
        return item
    }()
    
//    lazy var textView: UITextView = {
//        let item = UITextView()
//        item.backgroundColor = UIColor.systemYellow
//        return item
//    }()
    
    lazy var testLabel: UILabel = {
        let item = UILabel()
        item.text = "测试测试"
        item.backgroundColor = .green
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(200)
//            make.height.lessThanOrEqualTo(300)
//            make.height.greaterThanOrEqualTo(30)
        }
        
        
//        textView.attributedText = NSAttributedString(string: "测试文字 测试文字2 测试文字3 测试文字5 测试文字6 测试文字6 测试文字7", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.red])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog(view.layer.contentsScale)
        testLabel.frame = CGRect(x: 0, y: 200, width: 100, height: 100)
        view.addSubview(testLabel)
        //就只是上移  -> 0, - 300 , 100, 100
        var applyFrame = testLabel.frame.applying(CGAffineTransform(scaleX: 1.0, y: -1))
        testLabel.frame = applyFrame
    }
    
    // 结论 系统的textview 哪怕是在固定高度的情况下，复制一长串 字符串, 都会定位不准确。 eg:
    /*
     以下是一篇论文的模板，供您参考：

     标题：在这里写下您的论文标题

     摘要：在这里写下您的摘要，简要介绍您的研究目的、方法、结果和结论。

     关键词：在这里列出您的关键词，用逗号分隔。

     引言：在这里介绍您的研究背景和目的，以及您的研究对该领域的贡献。

     文献综述：在这里回顾和分析相关文献，介绍前人的研究成果和不足之处，以及您的研究与前人研究的关系。

     方法：在这里详细介绍您的研究方法，包括实验设计、样本选择、数据收集和分析等。

     结果：在这里呈现您的研究结果，包括数据、图表和统计分析等。

     讨论：在这里解释和分析您的研究结果，讨论您的研究对该领域的意义和贡献，以及您的研究的局限性和未来研究方向。

     结论：在这里总结您的研究成果和结论，强调您的研究对该领域的重要性和意义。

     参考文献：在这里列出您引用的文献，按照规定的格式排版。

     附录：在这里附上您的数据、图表和其他补充材料。

     以上是一篇论文的基本模板，您可以根据自己的研究内容和要求进行适当的修改和调整。
     */

}
