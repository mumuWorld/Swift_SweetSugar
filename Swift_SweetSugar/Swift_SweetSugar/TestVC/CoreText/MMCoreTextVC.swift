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
        item.backgroundColor = UIColor.white
        return item
    }()
    
    lazy var testLabel: UILabel = {
        let item = UILabel()
        item.text = "测试测试"
        item.backgroundColor = .green
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(100)
            make.leading.equalToSuperview()
            make.width.equalTo(100)
        }

        textView.attributeString = NSAttributedString(string: "测试文字 测试文字2 测试文字3 测试文字5 测试文字6 测试文字6 测试文字7", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.red])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog(view.layer.contentsScale)
        testLabel.frame = CGRect(x: 0, y: 200, width: 100, height: 100)
        view.addSubview(testLabel)
        //就只是上移  -> 0, - 300 , 100, 100
        var applyFrame = testLabel.frame.applying(CGAffineTransform(scaleX: 1.0, y: -1))
        testLabel.frame = applyFrame
    }

}
