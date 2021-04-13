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
        case 13:
            strTest()
        case 14:
            testNumber()
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
    
    func strTest() -> Void {
        let price = 2
           let number = 3
           let message = """
                          If one cookie costs \(price) dollars, \
                          \(number) cookies cost \(price * number) dollars.
                        """
        
        let message_2 = """
                if test \n
            hello \n
            world
            """
        mm_printLog(message)
        mm_printLog(message_2)
    }
    
    func testNumber() {
        //0.900000002  0.5
        let res1 = 1.8 / 2
        let res2 = 1.0 / 2
        // 0 0
        let res3 = Int(1.8 / 2)
        let res4 = Int(1.0 / 2)
        // 1 1
        let res5 = Int(1.9)
        let res6 = Int(1.1)
        
        mm_printsLog(res1, res2)
    }
}
