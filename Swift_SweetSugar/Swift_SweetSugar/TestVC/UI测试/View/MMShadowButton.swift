//
//  MMShadowButton.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/11/8.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

public class MMShadowButton: UIView {
    
    lazy var btn: UIButton = {
        let item = UIButton()
        item.layer.masksToBounds = true
        return item
    }()
    
     var cornerRadius: CGFloat {
         get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            btn.layer.cornerRadius = newValue
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
