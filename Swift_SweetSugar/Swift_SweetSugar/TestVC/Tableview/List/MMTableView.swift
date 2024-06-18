//
//  MMTableView.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/4/23.
//  Copyright © 2024 Mumu. All rights reserved.
//

import UIKit

class MMTableView: UITableView {
    
    var layoutComplete: (() -> Void)?

    override func layoutSubviews() {
        super.layoutSubviews()
        // 滚动时会无线回调。不可参考
//        print("test->layoutSubviews")
//        layoutComplete?()
    }

}
