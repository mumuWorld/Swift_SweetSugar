//
//  MMCustomView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/28.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMCustomView: UIView {

    lazy var control: MMControlView = MMControlView()
    
    var customName: String = "MMCustomView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(control)
        control.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(control)
        control.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("test->frame \(customName): \(frame)")
    }
    
    /// 移除window时也会调用
    /// - Parameter newWindow: 
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        mm_printLog("\(String(describing: newWindow))")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        mm_printLog("\(String(describing: self.window))")
    }
}
