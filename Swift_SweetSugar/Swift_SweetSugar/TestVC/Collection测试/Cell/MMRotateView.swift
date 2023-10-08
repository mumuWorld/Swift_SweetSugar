//
//  MMRotateView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/9/7.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

class MMRotateView: UIView {
    
    lazy var imgView: UIImageView = {
        let item = UIImageView()
        item.contentMode = .scaleAspectFill
        item.layer.cornerRadius = 20
        item.layer.cornerCurve = .continuous
        item.layer.masksToBounds = true
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //TODO: 杨杰-测试
        imgView.image = UIImage(named: "yww_1")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
