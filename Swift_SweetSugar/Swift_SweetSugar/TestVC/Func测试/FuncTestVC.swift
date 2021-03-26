//
//  FuncTestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

typealias emptyBlock = () -> ()

class FuncTestVC: UIViewController {

    var block: emptyBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func handleClick(_ sender: UIButton) {
        switch sender.tag {
        case 10:
            //此代码会造成循环引用
            self.block = testFunc
        case 11:
            //propertyWrapper 测试
            UserDefaultsUnit.test = "test_str"
        default:
            break
        }
    }

    func testFunc() -> Void {
        mm_printLog("test")
    }

    deinit {
        mm_printLog("释放")
    }
}
