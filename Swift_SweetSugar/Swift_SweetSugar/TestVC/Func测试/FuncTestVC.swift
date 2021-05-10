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
    
    var unit: UITableView = UITableView()
    
    lazy var removeItem: UIView? = {
        let item = UIView()
        return item
    }()
    
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
        case 15:
            testDict()
        case 16:
            errorTest()
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
    
    func testDict() -> Void {
        var transNameCodeDict = [String: String]()
        
        var simultaneousLanguageNameCodeDict = transNameCodeDict
//        var simultaneousLanguageCodeNameDict = transCodeNameDict
        transNameCodeDict["AutoDetectLanguage"] = "自动检测语言"
//        transCodeNameDict["自动检测语言"] = "AutoDetectLanguage"
        
        removeItem?.backgroundColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.secondTime(value: 2)) {
            self.removeItem = nil
        }
        mm_printLog("test")
    }
    
    func errorTest() -> Void {
        let error = MMError.MMNormalError.unknowError(message: nil)
        
        let data = Date().timeIntervalSince1970

        let str = " hello test mornigi \n test hehl "
        let str_2 = "hello test mornigi \n test hehl \n"
        let str_3 = " hello test mornigi \n test hehl \n "
        //"hello test mornigi \n test hehl"
        let str_t = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //"hello test mornigi \n test hehl"  替换前后换行 和 空格
        let str_2_t = str_2.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //"hello test mornigi \n test hehl \n"  替换前后空格
        let str_3_t = str_3.trimmingCharacters(in: CharacterSet.whitespaces)
        
        let tmpUnit = unit
        
        if tmpUnit == unit {
            mm_printLog("相等")
        }
        if tmpUnit === unit {
            mm_printLog("相等")
        }
        mm_printLog("error->\(error.reason)")
    }
}
