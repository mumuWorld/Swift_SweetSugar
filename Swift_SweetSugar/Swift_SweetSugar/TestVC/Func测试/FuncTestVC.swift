//
//  FuncTestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import SubProject_1

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
        case 12:
            cancelBlock()
        default:
            break
        }
        mm_printLog("->\(self.block) -> \(String(describing: testFunc))")
    }

    func testFunc() -> Void {
        mm_printLog("test")
        let test = ProjectOneTool()
        test.test()
    }

    deinit {
        mm_printLog("释放")
    }
}

extension FuncTestVC {
    //已经运行的block 无法取消
    func cancelBlock() -> Void {
        let operationQ = OperationQueue()
        operationQ.maxConcurrentOperationCount = 1
        
        let opera = BlockOperation {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.secondTime(value: 3)) {
                mm_printLog("三秒后执行")
            }
            sleep(3)
            mm_printLog("执行")
        }
        opera.cancel()
        operationQ.addOperation(opera)
        
        DispatchQueue.global().async {
            mm_printLog("执行取消")
            opera.cancel()
        }
                
    }
}
