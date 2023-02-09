//
//  MMFloatTextView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/1/9.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

class MMFloatTextView: UIView {

    lazy var textView: UITextView = {
        let item = UITextView(frame: .zero)
        return item
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.bottom.trailing.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog("touch->")
    }

}
