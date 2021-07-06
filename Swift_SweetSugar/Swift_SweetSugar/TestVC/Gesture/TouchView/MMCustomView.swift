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
    

}
