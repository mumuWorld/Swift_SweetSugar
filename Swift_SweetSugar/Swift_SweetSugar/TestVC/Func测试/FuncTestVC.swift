//
//  FuncTestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import AVFAudio
import CoreSpotlight
import CoreServices
//import SubProject_1

typealias emptyBlock = () -> ()

class FuncTestVC: UIViewController {
    
    let tool = MMFuncTool()

    var block: emptyBlock?
    
    var unit: UITableView = UITableView()
    
    var model: MMSimpleModel?
    
    lazy var mmView: MMCustomView = {
        let item = MMCustomView()
        return item
    }()
    
    lazy var removeItem: UIView? = {
        let item = UIView()
        return item
    }()
    
    @objc func test(p1:String, p2:String) {
        mm_printLog("p1-p2")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "123456"
        let word:String = title ?? ""
        let resxult = String(word[word.startIndex..<word.index(word.startIndex, offsetBy: 3)])
//        var arr: [UIBarButtonItem] = []
//        for i in 0...7 {
//            let btn = UIButton()
//            btn.setTitle("按钮\(i)", for: .normal)
//            btn.backgroundColor = .lightGray
//            let item = UIBarButtonItem(customView: btn)
//            arr.append(item)
//        }
//        navigationItem.rightBarButtonItems = arr
//        
//        var leftArr: [UIBarButtonItem] = []
//        for i in 0...7 {
//            let btn = UIButton()
//            btn.setTitle("按钮\(i)", for: .normal)
//            btn.backgroundColor = .lightGray
//            let item = UIBarButtonItem(customView: btn)
//            leftArr.append(item)
//        }
//        navigationItem.leftBarButtonItems = leftArr
        model?.name = "change"
        
        let index = Int(2.0 / 4.0)
        mm_printLog("")
//        relase 会打印
//        print("relase打印")
//        debugPrint("release_ debugPrint")
        decodeString()
      
        MMFuncTool().operationQueueTest()
        self.testPrint()
        
        let attrSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attrSet.contentDescription = "查词/拍照翻译/文档翻译/语音翻译"
        attrSet.thumbnailData = UIImage(named: "ic_mark_ocr")!.pngData()
        attrSet.keywords = ["词典", "翻译官", "有道", "翻译"]
        let activity = NSUserActivity(activityType: "com.mumu.test")
        activity.title = "测试标题"
        activity.userInfo = ["test": "testbody"]
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        }
        activity.contentAttributeSet = attrSet
        userActivity = activity
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let present = UIViewController.currentViewController() {
            // <Swift_SweetSugar.HomeListVC: 0x13f008e00>
            mm_printLog("test->\(present)")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let present = UIViewController.currentViewController() {
            // <Swift_SweetSugar.HomeListVC: 0x13f008e00>
            mm_printLog("test->\(present)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mm_printLog("")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let present = UIViewController.currentViewController() {
            // <Swift_SweetSugar.HomeListVC: 0x13f008e00>
            mm_printLog("test->\(present)")
        }
    }
    //MARK: - 都在这里

    @IBAction func handleClick(_ sender: UIButton) {
        switch sender.tag {
        case 10: break
            //此代码会造成循环引用
//            self.block = testFunc
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
            printTest()
        case 17:
            urlTest()
        case 18:
            typeTest()
        case 19:
            emojiTest()
        case 20:
            userdefaultTest()
        case 21:
            emptyTest()
        case 22:
            regularTest()
        case 23:
            speechSynthesisVoiceTest()
        case 24:
            stackTest()
        case 25:
            decodeString()
        case 26:
            MMFuncTool().past()
        case 27:
            tool.arrayTest()
        case 28:
            tool.deviceInfo()
        case 29:
            tool.testPrint2()
            tool.testPrint3()
        case 30:
            mmView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            view.addSubview(mmView)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                let vc = UITestVC()
                vc.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    vc.dismiss(animated: true)
                }
            }
        case 31:
            tool.jsonTest()
        case 32:
            if #available(iOS 15.0.0, *) {
                TaskGroupSampleTool().test2()
            } else {
                // Fallback on earlier versions
            }
        case 33:
            tool.rangeTest()
        case 34:
            tool.testAnaly()
        case 35:
            tool.dateTest()
        case 36:
            tool.timerTest36()
        case 37:
//            tool.urltest()
//            tool.deviceTest()
            tool.audioTest_37_2()
        case 38:
            tool.numberFormatter()
        case 39:
            tool.netTest()
        case 40:
            MMFileTest().readStr()
        case 41:
            MMFuncTool().crashTest()
        case 42:
            MMFuncTool().structTest()
        case 43:
            MMFuncTool().blockTest(vc: self)
        case 44:
            createTargetTimer()
        case 45:
            invalidateTimer()
        case 46:
//            do {
//                try AVAudioSession.sharedInstance().setActive(true, options: [])
//            } catch let e {
//                mm_printLog(e)
//            }
            let request = URLRequest(url: URL(string: "http://baidu.com")!)
            URLSession.shared.dataTask(with: request) { data, respon, error in
                mm_printLog(self)
                DispatchQueue.main.async {
//                    mm_printLog(self)
                }
            }.resume()
//            tool.test46()
        case 47:
            tool.nlTest()
        case 48:
            tool.kvoTest_48()
        case 49:
            MMLanguageTest().test()
        case 50:
            tool.stringTest_50()
        default:
            break
        }
//        mm_printLog("->\(self.block) -> \(String(describing: testFunc))")
    }
    
    var timer: Timer?
    
   
    
    func testFunc() -> Void {
        mm_printLog("test")
//        let test = ProjectOneTool()
//        test.test()
    }

    deinit {
//        invalidateTimer()
        mm_printLog("释放")
    }
}

extension FuncTestVC {
    
    func createTargetTimer() {
        //不停止不会释放
//        let _timer = Timer(timeInterval: 2, target: self, selector: #selector(handleTimer(sender:)), userInfo: nil, repeats: true)
//        timer = _timer
//        RunLoop.main.add(_timer, forMode: .common)
        
        //虽然没有持有vc， 但是持有了 block。 就算VC deinit， block还是会执行
        let _timer = Timer(timeInterval: 2, repeats: true) { [weak self] t in
            mm_printLog("test->\(t), \(String(describing: self))")
        }
        RunLoop.main.add(_timer, forMode: .common)
        timer = _timer
        timer?.fire()
    }
    
    /// 只要停止了timer。就会释放
    func invalidateTimer() {
        timer?.invalidate()
    }
    
    @objc func handleTimer(sender: Timer) {
        mm_printLog("test->\(sender)")
    }
    
    
    func decodeString() -> Void {
        let value = "AppVersion=4.0.0&brand=apple&client=iOS&logout=false&product=fanyi&push=on&token=545703ddeb3dd3d556249ced6b3e09b90e0288f2bc50d49ace39bd1a13ffc2cd"
        let result = value.data(using: .utf8, allowLossyConversion: false)!
        let url = URL(fileURLWithPath: "/Users/mumu/Desktop/二维码/result_sentence的副本.json")
        do {
            try result.write(to: url, options: .atomicWrite)
        } catch let e {
            mm_printLog(e)
        }
        let decode = String(data: result, encoding: .utf8)
        mm_printLog(result)
        let c: Character = "a"
        let str = String(c)
        
    }
    
    func stackTest() -> Void {
        let p1 = MMPoint(x: 1, y: 2)
        var p2 = p1
//        withUnsafePointer(to: &p1) { p in
//            UnsafeMutableRawPointer(p)
//        }
//        let str = String(format: "%p, %p",)
//        mm_printLog("\(str)")
        mm_printLog("\(Unmanaged.passUnretained(p1 as AnyObject).toOpaque()),\(Unmanaged.passUnretained(p2 as AnyObject).toOpaque())")
    }
    
    func speechSynthesisVoiceTest() -> Void {
        let arr = AVSpeechSynthesisVoice.speechVoices()
        mm_printLog(arr)
    }
    
    func regularTest() {
        let str = " "
        let result = str.mm_hasSpecialCharactor()
        
        let str_2 = "good"
        let result_2 = str_2.mm_hasSpecialCharactor()
        
        let str_3 = "mm+"
        let result_3 = str_3.mm_hasSpecialCharactor()
        mm_printLog("test")
    }
    
    @objc func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    func emptyTest() {
        var str: String? = " "
        let e1 = "".isEmpty
        let e2 = " ".isEmpty
        let e3 = str?.isEmpty
        let e4 = str!.isEmpty
        str = ""
        let e5 = str?.isEmpty
        let e6 = str!.isEmpty
        // true,false,Optional(false),false,Optional(true),true
        mm_printLog("\(e1),\(e2),\(e3),\(e4),\(e5),\(e6)")
        
        var str2: String?
        if str2?.isEmpty == true {   // nil == true => false
            mm_printLog("empty_1")
        }
        if str2?.isEmpty == false {   // nil == false => false
            mm_printLog("empty_2")
        }
        str2 = "1"
        if str2?.isEmpty == true {  // false
            mm_printLog("empty_2")
        }
        
        mm_printLog("end")
    }
    
    /// 添加 非 synchronize  第一次没有plist时可能耗时在此 0.007 0.001
    ///🔨[FuncTestVC userdefaultTest()](80): UserDefaults->0.007955064000270795
    ///🔨[FuncTestVC userdefaultTest()](99): UserDefaults->0.001040723999722104
    ///🔨[FuncTestVC userdefaultTest()](85): UserDefaults2->0.3899746900001446
    ///🔨[FuncTestVC userdefaultTest()](90): UserDefaults3->4.776035887000035
    ///🔨更新 value值未改变
    ///🔨[FuncTestVC userdefaultTest()](99): UserDefaults->0.00012117200003558537
    ///🔨[FuncTestVC userdefaultTest()](105): UserDefaults2->0.01495678700030112
    ///🔨[FuncTestVC userdefaultTest()](111): UserDefaults3->0.11341833899996345
    ///添加 synchronize
    ///🔨[FuncTestVC userdefaultTest()](92): UserDefaults->0.001109764000375435
    ///🔨[FuncTestVC userdefaultTest()](98): UserDefaults2->0.4162251910001942
    ///🔨[FuncTestVC userdefaultTest()](104): UserDefaults3->4.6923362510001425
    ///更新key value此时value改变
    ///🔨[FuncTestVC userdefaultTest()](95): UserDefaults->0.001175490000150603
    ///🔨[FuncTestVC userdefaultTest()](101): UserDefaults2->0.4427957829998377
    ///🔨[FuncTestVC userdefaultTest()](107): UserDefaults3->4.606776253999669
    /// 更新key value  sync 此时value未改变
    ///🔨[FuncTestVC userdefaultTest()](86): UserDefaults->0.00014505399985864642
    ///🔨[FuncTestVC userdefaultTest()](92): UserDefaults2->0.014028745999894454
    ///🔨[FuncTestVC userdefaultTest()](98): UserDefaults3->0.09163771099974838
    /// - Returns:
    func userdefaultTest() -> Void {
        let ud = UserDefaults.standard
        let key = "save_2"
//        ud.set(true, forKey: key)
        let valeu = ud.string(forKey: key)
        ud.set("4.0.4", forKey: key)
        let value_2 = ud.bool(forKey: key)
        
        var start_t = CACurrentMediaTime()
//        mm_printLog("UserDefaults->\(start_t)")
//        ud.setValue("value2", forKey: "key")
////        ud.synchronize()
//        mm_printLog("UserDefaults->\(CACurrentMediaTime() - start_t)")
//        start_t = CACurrentMediaTime()
//        for i in 0...1000 {
//            ud.setValue(String(format: "value2%d", i), forKey: String(format: "key%d", i))
//        }
////        ud.synchronize()
//        mm_printLog("UserDefaults2->\(CACurrentMediaTime() - start_t)")
//        start_t = CACurrentMediaTime()
//        for i in 1000...11000 {
//            ud.setValue(String(format: "value2%d", i), forKey: String(format: "key%d", i))
//        }
////        ud.synchronize()
//        mm_printLog("UserDefaults3->\(CACurrentMediaTime() - start_t)")
        
    }
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
//        let price = 2
//           let number = 3
//           let message = """
//                          If one cookie costs \(price) dollars, \
//                          \(number) cookies cost \(price * number) dollars.
//                        """
//
//        let message_2 = """
//                if test \n
//            hello \n
//            world
//            """
//        mm_printLog(message)
//        mm_printLog(message_2)
        let a: String = "汉"
        let b: String = "斐"
        let e: String = "🌹"
        let c: String = "a"

        let char_a = (a as NSString).character(at: 0)
        let char_b =  (b as NSString).character(at: 0)
        
        let a_ns = (a as NSString)
        let c_ns = (c as NSString)
        let e_ns = (e as NSString)
        
        let code = a.utf16
        mm_printLog(char_a)
        
        let flowers = "Flowers 💐"
         for v in flowers.utf8 {
             mm_printLog(v)
           }
        mm_printLog("-----------")
        for v in flowers.utf16 {
            mm_printLog(v)
          }
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
    
    func printTest() -> Void {
        let error = MMError.MMNormalError.unknowError(message: nil)
        // 1638244301.8361139  秒
        let data = Date().timeIntervalSince1970 * 1000
        let strdata = String(format: "%i", data)
        let str = " hello test mornigi \n test hehl "
        let str_2 = "hello test mornigi \n test hehl \n"
        let str_3 = " hello test mornigi \n test hehl \n "
        
        let str_4 = "           "

        //"hello test mornigi \n test hehl"
        let str_t = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //"hello test mornigi \n test hehl"  替换前后换行 和 空格
        let str_2_t = str_2.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //"hello test mornigi \n test hehl \n"  替换前后空格
        let str_3_t = str_3.trimmingCharacters(in: CharacterSet.whitespaces)
        /// "" 全部替换
        let str_4_t = str_4.trimmingCharacters(in: .whitespacesAndNewlines)

        let tmpUnit = unit
        
        if tmpUnit == unit {
            mm_printLog("相等")
        }
        if tmpUnit === unit {
            mm_printLog("相等")
        }
        mm_printLog("error->\(error.reason)")
    }
    
    func typeTest() {
        /*
         Printing description of name_1:
         "<Swift_SweetSugar.FuncTestVC: 0x7fea3ae29450>"
         Printing description of name_2:
         "FuncTestVC"
         Printing description of name_3:
         "FuncTestVC"
         Printing description of name_4:
         "<Swift_SweetSugar.FuncTestVC: 0x7fea3ae29450>"
         */
        let name_1 = String(describing: self)
        let name_2 = String(describing: type(of: self))
        let name_3 = String(describing: type(of: self.self))
        let name_4 = String(describing: self.self)
        mm_printLog("1/2/3/4")
    }
    
    func emojiTest() {
        let str = "ab我cd🤩😁haha"
        let nsStr = str as NSString
        // count=11, 19,13, nsStr=13， nsstring中使用的 utf16格式的长度
        // utf8中，中文4个了， emoji为4个 ，在utf16中 emoji长度为2, 中文为1，
        mm_printLog("count=\(str.count), \(str.utf8.count),\(str.utf16.count), nsStr=\( nsStr.length)")
        let str_1 = str.substring(to: 6) // hello🤩
        let str_2 = str.substring(to: 7) // hello🤩😁
        
        let nsStr_1 = nsStr.substring(to: 6) // ab我cd�
        let nsStr_2 = nsStr.substring(to: 7) // ab我cd🤩
        let nsStr_3 = nsStr.substring(to: 8) // ab我cd🤩�
        
        let str2 = "trans_beliefs"
        let str2_1 = str2.substring(from: 5)
        /*
         ab我cd🤩😁ha{
             NSFont = "<UICTFont: 0x7f917c832460> font-family: \".SFUI-Regular\"; font-weight: normal; font-style: normal; font-size: 30.00pt";
         }ha{
         }
         */
        let mutAttr = NSMutableAttributedString(string: str)
        mutAttr.addAttribute(.font, value: UIFont.systemFont(ofSize: 30), range: str.mm_range())
        //lenght= 13, 11, mutattr 中的length 也是 用的utf16格式的长度
        mm_printLog("lenght=\(mutAttr.length), \(mutAttr.string.count) ")
        /*
         ab我cd🤩😁haha{
             NSFont = "<UICTFont: 0x7ffb60663950> font-family: \".SFUI-Regular\"; font-weight: normal; font-style: normal; font-size: 30.00pt";
         }
         */
        let mutAttr_2 = NSMutableAttributedString(string: nsStr as String)
        mutAttr_2.addAttribute(.font, value: UIFont.systemFont(ofSize: 30), range: nsStr.mm_range())
        
        mm_printLog("1/2/3/4")
        
        let composeRange = str.rangeOfComposedCharacterSequence(at: str.index(str.startIndex, offsetBy: 5))
        let str_c = str[composeRange]
        mm_printLog("1/2/3/4")
    }
    
    func timeTest() {
        
    }
    
    func urlTest() {
//        let string = "https://baike.baidu.com/item/冒泡排序/4602306?fr=aladdin".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let string = "https%3A%2F%2Fbaike.baidu.com%2Fitem%2F%E5%86%92%E6%B3%A1%E6%8E%92%E5%BA%8F%2F4602306%3Ffr%3Daladdin"
        let urlStr_7 = """
        https://h5.youdao.com/preview/1025?_t=1681289492028&title=一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                        一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                        一二三四一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                        一二三四一二三四一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                        一二三四一二三四一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                        一二三四一二三四一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                        一二三四一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                一二三四一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                一二三四一二三四一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                一二三四一二三四一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                一二三四一二三四一二三四九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四
                一二三四
        """
        let urlAdapt_7 = urlStr_7.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url_7 = URL(string: urlAdapt_7)
        mm_printLog("test->2")
        
        let string = """
        %0A%0A%0AHOME%0A%0A%0ACHINA%0A%0A%0ASOURCE%0A%0A%0AOPINION%0A%0A%0AHU%20SAYS%0A%0A%0AIN-DEPTH%0A%0A%0AWORLD%0A%0A%0ALIFE%0A%0A%0ASPORT%0A%0A%0AVIDEO%0A%0A%0APHOTO%0A%0A%0AINFOGRAPHIC%0A%0A%0ACHINA%0A%0A%0APolitics%0A%0A%0ASociety%0A%0A%0ADiplomacy%0A%0A%0AMilitary%0A%0A%0AScience%0A%0A%0AOdd%0A%0A%0AChina%20Graphic%0A%0A%0ASOURCE%0A%0A%0AGT%20Voice%0A%0A%0AInsight%0A%0A%0AEconomy%0A%0A%0AComments%0A%0A%0ACompany%0A%0A%0AB&R%20Initiative%0A%0A%0ABiz%20Graphic%0A%0A%0AOPINION%0A%0A%0AEditorial%0A%0A%0AObserver%0A%0A%0AAsian%20Review%0A%0A%0ATop%20Talk%0A%0A%0AViewpoint%0A%0A%0AColumnists%0A%0A%0ACartoon%0A%0A%0AHU%20SAYS%0A%0A%0AHu%20Says%0A%0A%0AIN-DEPTH%0A%0A%0AIn-Depth%0A%0A%0AWORLD%0A%0A%0AEye%20on%20World%0A%0A%0AAmerica%0A%0A%0AAsia-Pacific%0A%0A%0AEurope%0A%0A%0AAfrica%0A%0A%0AMid-East%0A%0A%0ACross-borders%0A%0A%0ALIFE%0A%0A%0ACulture%0A%0A%0AEntertainment%0A%0A%0ATravel%0A%0A%0ALearning%20Chinese%0A%0A%0ASPORT%0A%0A%0ASport%0A%0A%0AVIDEO%0A%0A%0AGot-to-watch%0A%0A%0APHOTO%0A%0A%0AGallery%0A%0A%0AChina%0A%0A%0AWorld%0A%0A%0ABiz%0A%0A%0ASport%0A%0A%0AINFOGRAPHIC%0A%0A%0AJimmy%20Lai%20gets%2014%20more%20months%20for%20illegal%20assembly,%20a%20further%20signal%20...%0A%0A%0AHong%20Kong%20media%20tycoon%20Jimmy%20Lai%20Chee-ying%20was%20sentenced%2014%20months%20in%20prison%20on%20Friday%20alongside%20nine%20others,%20including%20several%20...%0A%0A%0ABiden%20team%20resorts%20to%20confrontation%20to%20'cover%20declining%20confidence,%20failed%20governance'%0A%0A%0AOn%20surface,%20the%20Biden%20administration%20stresses%20%22competition%22,%20instead%20of%20confrontation%20pursued%20by%20its%20predecessors,%20but%20the%20US%20is%20actually%20becoming%20...%0A%0A%0AYouth%20appreciate%20CPC%20history%20%E2%80%93%20in%20innovative%20ways%20%E2%80%93%20and%20strengthen%20faith%20...%0A%0A%0ACollege%20graduate%20Zhou%20Ying,%2022,%20had%20never%20thought%20she%20would%20one%20day%20become%20addicted%20to%20learning%20about%20the%20history%20of%20...%0A%0A%0AHong%20Kong%20finalizes%20local%20amendments%20for%20election%20overhaul%20%20%20%20%20%20%20%20With%20the%20Legislative%20Council%20(LegCo)%20completing%20a%20review%20of%20a%20number%20of%20amendments%20on%20Thursday%20as%20part%20of%20the%20improvement%20...%0A%0A%0ACHINA%0A%0A%0APolitics%0A%0A%0ASociety%0A%0A%0ADiplomacy%0A%0A%0AMilitary%0A%0A%0AScience%0A%0A%0AOdd%0A%0A%0AChina%20Graphic%0A%0A%0ASOURCE%0A%0A%0AGT%20Voice%0A%0A%0AInsight%0A%0A%0AEconomy%0A%0A%0AComments%0A%0A%0ACompany%0A%0A%0AB&R%20Initiative%0A%0A%0ABiz%20Graphic%0A%0A%0AOPINION%0A%0A%0AEditorial%0A%0A%0AObserver%0A%0A%0AAsian%20Review%0A%0A%0ATop%20Talk%0A%0A%0AViewpoint%0A%0A%0AColumnists%0A%0A%0ACartoon%0A%0A%0AWORLD%0A%0A%0AEye%20on%20World%0A%0A%0AAmerica%0A%0A%0AAsia-Pacific%0A%0A%0AEurope%0A%0A%0AAfrica%0A%0A%0AMid-East%0A%0A%0ACross-borders%0A%0A%0ALIFE%0A%0A%0ACulture%0A%0A%0AEntertainment%0A%0A%0ATravel%0A%0A%0ALearning%20Chinese%0A%0A%0AVISUAL%20NEWS%0A%0A%0AHU%20SAYS%0A%0A%0AVideo%0A%0A%0AGraphics%0A%0A%0AGallery%0A%0A%0ASpecials%0A%0A%0AMISCELLANEOUS%0A%0A%0AIn-Depth%0A%0A%0ASport%0A%0A%0ALINKS%0A%0A%0AQiushi%20Journal%0A%0A%0APeople's%20Daily%0A%0A%0APeople's%20Daily%20APP%0A%0A%0A%E7%8E%AF%E7%90%83%E7%BD%91%0A%0A%0AEcns.cn
        """
        let string_2 = """
        %0A%0A%0AHOME%0A%0A%0ACHINA%0A%0A%0ASOURCE%0A%0A%0AOPINION%0A%0A%0AHU%20SAYS%0A%0A%0AIN-DEPTH%0A%0A%0AWORLD%0A%0A%0ALIFE%0A%0A%0ASPORT%0A%0A%0AVIDEO%0A%0A%0APHOTO%0A%0A%0AINFOGRAPHIC%0A%0A%0ACHINA%0A%0A%0APolitics%0A%0A%0ASociety%0A%0A%0ADiplomacy%0A%0A%0AMilitary%0A%0A%0AScience%0A%0A%0AOdd%0A%0A%0AChina%20Graphic%0A%0A%0ASOURCE%0A%0A%0AGT%20Voice%0A%0A%0AInsight%0A%0A%0AEconomy%0A%0A%0AComments%0A%0A%0ACompany%0A%0A%0AB%26R%20Initiative%0A%0A%0ABiz%20Graphic%0A%0A%0AOPINION%0A%0A%0AEditorial%0A%0A%0AObserver%0A%0A%0AAsian%20Review%0A%0A%0ATop%20Talk%0A%0A%0AViewpoint%0A%0A%0AColumnists%0A%0A%0ACartoon%0A%0A%0AHU%20SAYS%0A%0A%0AHu%20Says%0A%0A%0AIN-DEPTH%0A%0A%0AIn-Depth%0A%0A%0AWORLD%0A%0A%0AEye%20on%20World%0A%0A%0AAmerica%0A%0A%0AAsia-Pacific%0A%0A%0AEurope%0A%0A%0AAfrica%0A%0A%0AMid-East%0A%0A%0ACross-borders%0A%0A%0ALIFE%0A%0A%0ACulture%0A%0A%0AEntertainment%0A%0A%0ATravel%0A%0A%0ALearning%20Chinese%0A%0A%0ASPORT%0A%0A%0ASport%0A%0A%0AVIDEO%0A%0A%0AGot-to-watch%0A%0A%0APHOTO%0A%0A%0AGallery%0A%0A%0AChina%0A%0A%0AWorld%0A%0A%0ABiz%0A%0A%0ASport%0A%0A%0AINFOGRAPHIC%0A%0A%0ABiden%20team%20resorts%20to%20confrontation%20to%20%27cover%20declining%20confidence%2C%20failed%20governance%27%0A%0A%0AOn%20surface%2C%20the%20Biden%20administration%20stresses%20%22competition%22%2C%20instead%20of%20confrontation%20pursued%20by%20its%20predecessors%2C%20but%20the%20US%20is%20actually%20becoming%20...%0A%0A%0AYouth%20appreciate%20CPC%20history%20%E2%80%93%20in%20innovative%20ways%20%E2%80%93%20and%20strengthen%20faith%20...%0A%0A%0ACollege%20graduate%20Zhou%20Ying%2C%2022%2C%20had%20never%20thought%20she%20would%20one%20day%20become%20addicted%20to%20learning%20about%20the%20history%20of%20...%0A%0A%0AHong%20Kong%20finalizes%20local%20amendments%20for%20election%20overhaul%0A%0A%0AWith%20the%20Legislative%20Council%20%28LegCo%29%20completing%20a%20review%20of%20a%20number%20of%20amendments%20on%20Thursday%20as%20part%20of%20the%20improvement%20...%0A%0A%0ADPP%27s%20pursuit%20of%20political%20interests%20comes%20at%20cost%20of%20people%27s%20lives%20amid%20...%20%20%20%20%20%20%20%20Turning%20a%20blind%20eye%20to%20the%20increasingly%20rampant%20outbreak%20of%20COVID-19%20epidemic%20on%20the%20island%20of%20Taiwan%2C%20with%20new%20local%20...%0A%0A%0ACHINA%0A%0A%0APolitics%0A%0A%0ASociety%0A%0A%0ADiplomacy%0A%0A%0AMilitary%0A%0A%0AScience%0A%0A%0AOdd%0A%0A%0AChina%20Graphic%0A%0A%0ASOURCE%0A%0A%0AGT%20Voice%0A%0A%0AInsight%0A%0A%0AEconomy%0A%0A%0AComments%0A%0A%0ACompany%0A%0A%0AB%26R%20Initiative%0A%0A%0ABiz%20Graphic%0A%0A%0AOPINION%0A%0A%0AEditorial%0A%0A%0AObserver%0A%0A%0AAsian%20Review%0A%0A%0ATop%20Talk%0A%0A%0AViewpoint%0A%0A%0AColumnists%0A%0A%0ACartoon%0A%0A%0AWORLD%0A%0A%0AEye%20on%20World%0A%0A%0AAmerica%0A%0A%0AAsia-Pacific%0A%0A%0AEurope%0A%0A%0AAfrica%0A%0A%0AMid-East%0A%0A%0ACross-borders%0A%0A%0ALIFE%0A%0A%0ACulture%0A%0A%0AEntertainment%0A%0A%0ATravel%0A%0A%0ALearning%20Chinese%0A%0A%0AVISUAL%20NEWS%0A%0A%0AHU%20SAYS%0A%0A%0AVideo%0A%0A%0AGraphics%0A%0A%0AGallery%0A%0A%0ASpecials%0A%0A%0AMISCELLANEOUS%0A%0A%0AIn-Depth%0A%0A%0ASport%0A%0A%0ALINKS%0A%0A%0AQiushi%20Journal%0A%0A%0APeople%27s%20Daily%0A%0A%0APeople%27s%20Daily%20APP%0A%0A%0A%E7%8E%AF%E7%90%83%E7%BD%91%0A%0A%0AEcns.cn
        """
        mm_printLog("str_1=\(string.count)")
        mm_printLog("str_1=\(string_2.count)")

        let str_1 = string.urlEncoded()
        
        let str_2 = string.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]")) ?? "error"
        
        mm_printLog("str_1=\(str_1)")
        mm_printLog("str_1=\(str_2)")

//        let t_url: URL
//        guard let url = URL(string: string) else {
//            mm_printLog("生不成url")
//            return
//        }
//        t_url = url
//        if t_url.scheme?.lowercased().hasPrefix("http") ?? false {
//            mm_printLog("是URL")
//            return
//        }
        mm_printLog("不是URL")
        return
    }
}
