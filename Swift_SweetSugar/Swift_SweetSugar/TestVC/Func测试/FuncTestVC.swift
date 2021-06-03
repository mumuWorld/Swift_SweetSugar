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
        case 17:
            urlTest()
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
    
    func urlTest() {
//        let string = "https://baike.baidu.com/item/冒泡排序/4602306?fr=aladdin".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let string = "https%3A%2F%2Fbaike.baidu.com%2Fitem%2F%E5%86%92%E6%B3%A1%E6%8E%92%E5%BA%8F%2F4602306%3Ffr%3Daladdin"
        
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
