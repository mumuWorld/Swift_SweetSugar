//
//  ViewController.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/4/1.
//  Copyright © 2019年 Mumu. All rights reserved.
//

import UIKit
//import Kingfisher
//import mmhome

enum Season: Int {
    case spring = 0,summer
}

class ViewController: UIViewController {
    let solution = Solution()
    let strSolution = StringSolution()

    var targetVC: UIViewController?

    @IBOutlet weak var testImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let arr = CreateTool.createIntArray(count: 10, minP: 0, maxP: 100)
        //        if let octor = CFAllocatorGetDefault() {

        var arr:[[Int]] = [[1,3,1],[1,5,1],[4,2,1]]
        let str = "/../"
        var consolution: LeetCodeTureSubject = LeetCodeTureSubject()
//        let result = consolution.rob(arr);
//        let result = consolution.minPathSum(arr)
//        let result = consolution.simplifyPath(str)
//        let result = consolution.minDistance("horse", "ho")
        var inputArr = [0,1,1,2,2,3]
        let result = consolution.removeDuplicates(&inputArr)
        mm_printsLog(result)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//          let window = UIWindow(frame: CGRect(x: 100, y: 200, width: 100, height: 200))
//                window.backgroundColor = .green
////                window.windowLevel = .alert
//        
//                window.isHidden = false
//        window.alpha = 1
////        window.makeKey()
//                window.makeKeyAndVisible()
    }
    /// 验证
    /// - Parameter parm1: 此时param1 必须不为空 并且必须不是可选类型
    /// - Parameter param2: 等同于 param3 可为可选类型 也可为nil
//    🔨 ["param1->must not nil,param2->nil,param3->nil"]
//    🔨 ["param1->test,param2->Optional(\"test\"),param3->Optional(\"test\")"]
//    🔨 ["param1->test2,param2->Optional(\"test2\"),param3->Optional(\"test2\")"]
    func paramTest(parm1: String, param2: String?, param3: String!) -> Void {
        mm_printsLog("param1->\(parm1),param2->\(param2),param3->\(param3)")
//        if param3 != nil {
//           mm_printLog(message: param3 + "test")
//        }
//        mm_printLog(message: param2 + "test")
        var tValue  = 10
        while tValue > 0 {
            mm_printLog(tValue)
        }
        
    }
    
        
    //    func paramTest2(param: String) -> Void {
    //        mm_printsLog(param)
    //    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
//        sort()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        sum2()
        sort()
//        let vc = MonitorViewController()
//        present(vc, animated: true, completion: nil)
//        MMFileTest().testF_1()
        
//        do {
//            try MMFileTest.direcotryProperty()
//            try MMFileTest.itemProperty()
//        } catch {
//
//        }
    }
    
    func sum1() -> Void {
        let nums = [-1,0,1,2,-1,-4]
        
        let result =  solution.threeSum(nums)
        print(result)
    }
    func sol3() -> Void {
        let str = "aba"// abccbde
        let result =  strSolution.longestPalindrome(str)
        print(result)
    }
    func sort() -> Void {
        let randomArr = CreateTool.createIntArray(count: 10, minP: 10, maxP: 1000)

//        let arr = [77, 27, 44, 73, 30, 33,  20]
        mm_printLog(randomArr)
        let merge = MergeSort(arr: randomArr).sort()
//        let quick = QuickSort().sort(arr: randomArr)
        mm_printLog(merge)
//        print(randomArr)
//        CreateTool.timeRecord(title: "冒泡") {
////            BaseSort.popSort(arr: &randomArr)
//            BaseSort.selectedSort(arr: &randomArr)
//        }
//        print(randomArr)
    }
    
    func runloopTest() -> Void {
                let observe = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.allActivities.rawValue, true, 0) { (observe, activity) in
        //            mm_printsLog(activity)
                    switch activity {
                    case .entry:
                        mm_printsLog("entry")
                    case .beforeTimers:
                        mm_printsLog("beforeTimers")
                    case .beforeSources:
                        mm_printsLog("beforeSources")
                    case .beforeWaiting:
                        mm_printsLog("beforeWaiting")
                    case .afterWaiting:
                        mm_printsLog("afterWaiting")
                    case .exit:
                        mm_printsLog("exit")
                    default:
                        mm_printsLog("未知")
                        break
                    }
                    //        }
                   
                }
                 CFRunLoopAddObserver(CFRunLoopGetCurrent(), observe, CFRunLoopMode.commonModes)
    }
    
    func sum2() -> Void {
        let str = "sefefe"
        let length = strSolution.lengthOfLongestSubstring(str)
        print(length)
    }

}

