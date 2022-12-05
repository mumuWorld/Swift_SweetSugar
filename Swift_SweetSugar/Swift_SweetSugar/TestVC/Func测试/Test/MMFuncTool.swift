//
//  MMFuncTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/27.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import AVFoundation

class MMFuncTool: NSObject {
    
    func urltest() -> Void {
        let urlStr = "https://shared.youdao.com/dict/market/living-study-ranking-test/index.html#/?hide-toolbar=true"
        let urlStr_2 = "https://shared.youdao.com/dict/market/training-camp-test/index.html/campDetails"
        let urlStr_3 = "https://shared.youdao.com/dict/market/living-study-ranking-test?hide-toolbar=true/#/"
        
        let encode_url = urlStr.urlEncoded()
        
        let component = URLComponents(string: urlStr)
        var component_2 = URLComponents(string: urlStr_2)
        
        component_2?.queryItems?.append(URLQueryItem(name: "name", value: "test"))
        
        let component_3 = URLComponents(string: urlStr_3)

        let component_4 = URLComponents(string: encode_url)

        let charSet = CharacterSet.urlQueryAllowed
        
        let url = URL(string: urlStr)
        mm_printLog("test->1")
        
        let params: [String: String] = [
            "goodInfo": "{dsdfsdf}",
            "nickname": "{dsdfsdf}",
            "avatar": "{dsdfsdf}",
            "userId": "{dsdfsdf}",
        ]
        let paramsStr = params.map { key, value in
            return "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }.joined(separator: "&")
        
        let urlStr_4 = "http://baidu.com?" + paramsStr
        
        let url_2 = URL(string: urlStr_4)
        
        let urlStr_5 = "https://shared.youdao.com/dict/market/shop-window-test/?noShare=true&full-screen=true&adjustSafeArea=true&hide-toolbar=true&hide-toolbar=true&postType=VIDEO&avatar=https%3A%2F%2Fydlunacommon-cdn.nosdn.127.net%2F9ea7678834227363caeb05dd1d9e99cc.png&nickname=urs%2A%2A%2A%2A%2A%2Acom&userId=urs-phoneyd.cda14678cacf43fea%40163.com&goodInfo=%7B%22id%22%3A3908%2C%22category%22%3A33%2C%22backupLandingPageUrl%22%3A%22https%3A%5C%2F%5C%2Fwww.baidu.com%5C%2F%22%2C%22schemaId%22%3A3%2C%22activeClosed%22%3Afalse%2C%22itemPrice%22%3A10000%2C%22promotionType%22%3A2%2C%22buttonText%22%3A%22%E8%B4%AD%E4%B9%B0%22%2C%22itemName%22%3A%22deeplink%E5%BC%95%E5%AF%BC%E6%96%87%E6%A1%88%22%2C%22source%22%3A0%2C%22switchType%22%3A2%2C%22componentId%22%3A%22dAYwySUtbY%22%2C%22promoteImageUrl%22%3A%22http%3A%5C%2F%5C%2Foimagec4.ydstatic.com%5C%2Fimage%3Fid%3D4030997507705062280%26product%3Dadpublish%26format%3DJPEG%22%2C%22strikeThroughPrice%22%3A10000%2C%22leadText%22%3A%22deeplink%E5%BC%95%E5%AF%BC%E6%96%87%E6%A1%88%22%2C%22markAsAd%22%3Atrue%2C%22name%22%3A%22deeplin%22%2C%22deepLink%22%3A%22bilibili%3A%5C%2F%5C%2Fsearch%5C%2F%25E8%2580%2583%25E7%25A0%2594%3Fh5awaken%3Db3Blbl9hcHBfZnJvbV90eXBlPWRlZXBsaW5rX21hcmtldGluZy1rYW95YW4mb3Blbl9hcHBfdXJsPXNlYXJjaC1rYW95YW4tMQ%3D%3D%22%7D#/more"
        let url_3 = URL(string: urlStr_5)
        let com = URLComponents(string: urlStr_5)
        
        let urlStr_6 = "https://shared.youdao.com/dict/market/living-study-ranking-test/?t=1668069073944&authorId=urs-phoneyd.688d91f7dca547289%40163.com&hide-toolbar=true&userId=course_test%40163.com&liveRoomId=34511893&authorName=%E4%BB%8A%E5%A4%A9%E4%B9%9F%E8%A6%81%E5%A5%BD%E5%A5%BD%E5%8A%AA%E5%8A%9B%E5%91%80&full-screen=true"
        let url_4 = URL(string: urlStr_6)
        mm_printLog("test->2")
    }
    
    func jsonTest() {
        let str = "{\"msgID\":\"1478746890721\",\"title\":\"push_update\",\"type\":\"notice\",\"url\":\"yddict://youdao.com/guidingpage?liveRoomId=123122312\"}"
        let json = JSON.init(parseJSON: str)
        
        let str_2 = ""
        mm_printLog("test->")
    }
    
    var timerStr: String?
    
    func past() {
//        UIPasteboard.general.string = "http://hellow world"
        let pasted = UIPasteboard.general
        if #available(iOS 14.0, *) {
            pasted.detectPatterns(for: Set(arrayLiteral: UIPasteboard.DetectionPattern.probableWebSearch, .probableWebURL, .number)) { result in
                switch result {
                case .success(let results):
                    for item in results {
                        if item == .probableWebSearch {
                            mm_printLog("测试1")
                        } else if item == .number {
                            mm_printLog("测试2")
                        } else if item == .probableWebURL {
                            mm_printLog("测试3")
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        } else {
            
        }
        mm_printLog("str->\(pasted.string)")
        mm_printLog("str->\(pasted.strings)")

    }
    
    func makeData(s: String) {
//        s.data(using: .utf8).map {
////            JSONSerialization.jsonObject(with: <#T##Data#>, options: <#T##JSONSerialization.ReadingOptions#>)
//            try? JSONSerialization.jsonObject(with: $0, options: .fragmentsAllowed)
//        }?.map({
//            MMFuncTool()
//        })
    }
    
    func operationQueueTest() {
        let operation = Operation()
        operation.completionBlock = {
            mm_printLog("finished")
        }
        OperationQueue.main.addOperation(operation)
        
        MMFuncTool.add(a: 1, b: 3) { result in
            mm_printLog(result)
        }
    }
    
    static func add(a: Int, b: Int, block: @escaping ((Int) -> Void)) {
        OperationQueue.main.addOperation {
            block(a + b)
        }
    }
    
    func blockTest(vc: FuncTestVC) {
        blockDemoFunc { [weak self, weak vc] tool, vc in
            
        }
    }
    func blockDemoFunc(b: ((_ tool: MMFuncTool,_ vc: FuncTestVC) -> Void)) {
    
    }
    
    
//    var dataArray: [Data] = [Data]()
    var dataArray: [String] = [String]()

    
    let backQueue = DispatchQueue(label: "com.mumu.back", attributes: .concurrent)
    let backQueue2 = DispatchQueue(label: "com.mumu.back_2", attributes: .concurrent)
    func arrayTest() -> Void {
        //串行执行，但是不会执行100000次，
//        DispatchQueue.global().async {
//    //            DispatchQueue.global().async {
//            for i in 0...100000 {
//                self.backQueue.async {
//                    self.dataArray.append(String(format: "%d", i))
//                    mm_printLog(i)
//                }
//            }
//        }
//        backQueue.sync(flags: .barrier) {
//            
//        }
//        DispatchQueue.global().async {
//            
//        for i in 0...100000 {
////            DispatchQueue.global().async {
//            self.backQueue2.async {
//                let roundtripTimes = self.dataArray.filter { $0.count > 2 }
////                self.dataArray.append(String(format: "2_%d", i))
//                mm_printLog(i)
//            }
//        }
//        }
//        backQueue.async {
//            for i in 0...100000 {
//            self.dataArray.append(String(format: "%d", i))
//            mm_printLog(i)
//            }
//        }
//        var preArr: [Int] = []
//        preArr.reserveCapacity(100)
//        // capacity = 100
//        preArr.append(1)
//        //会移除所申请的空间 capacity = 0
//        preArr.removeAll()
        
//        let removeArr1: [Int] = [0,1,2,3,4,5]
        //会全部filter一遍
//        let tmpArr = removeArr1.filter { item in
//            mm_printLog("item->\(item)")
//            return item < 4
//        }.prefix(2).map({ $0 * 2 })
        
        
        var toolStrArr: [String] = ["0","1","2","3","4"]

        var toolArr: [Int] = [0,1,2,3,4,5]
        var toolOptionStrArr: [String?] = ["0","1","str","3"]

        //17 -> 2 + 0 + 1 + 2 + 3 + 4 + 5
        let r1 = toolArr.reduce(2) { partialResult, item in
            return partialResult + item
        }
        //result->01234  累加
        let r2 = toolStrArr.reduce("result->") { partialResult, item in
            return partialResult + item
        }
        // r3 -> [[0], [1]]
        let r3 = toolStrArr.map { item in
            return [item]
        }
        //过滤数组元素 r4 -> [0, 2, 4]
        let r4 = toolArr.filter { item in
            return item % 2 == 0
        }
        //r5 = [Int], [0, 1, 2, 3,4, 5] 废弃
        let r5 = toolArr.flatMap { item in
            return [item]
        }
        let r6 = toolArr.compactMap { item in
            
        }
        var removeArr: [Int] = [0,1,2,3,4,5]
        //保留【1，5】
        removeArr.removeSubrange(1..<(removeArr.count - 1))
        var removeArr2: [Int] = [0,1]
        //不变
        removeArr2.removeSubrange(1..<(removeArr2.count - 1))
        var removeArr3: [Int] = [0]
        //Thread 1: Fatal error: Range requires lowerBound <= upperBound
//        removeArr3.removeSubrange(1..<(removeArr3.count - 1))
        
        var emptyArr: [Int] = []
        //不会崩， item = nil
        let item = emptyArr.last
        //不会crash
        emptyArr.removeAll()
        //不会crash
        let filter = Array(emptyArr.prefix(6))
        if let model: MMSimpleModel = nil {
            mm_printLog("不会走")
        }
        //会crash
//        emptyArr.removeFirst()
        mm_printLog("")
        let mutableArr: NSMutableArray = NSMutableArray()
        mutableArr.add(NSNull())
        mutableArr.add(NSString(string: "test"))
        
        var objArr: [NSString] = mutableArr as! [NSString]
        
        var jsonModel = MMJsonNode()
        jsonModel.childs = mutableArr
        if let arr = jsonModel.childs as? [MMJsonNode] {
            mm_printLog("会走\(arr)")
        }
        if let model = objArr[hold: 0] {
            mm_printLog("会走\(model.length)")
//            , !model.isKind(of: NSNull.self)
        }
        
        let array: [String] = []
        let index = (array.startIndex..<array.endIndex)
        let c1 = index.contains(0)
        mm_printLog("")
    }
    
    func numberFormatter() {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.usesGroupingSeparator = false
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1    //小数点后1位
        nf.decimalSeparator = "."
        nf.roundingMode = .down
        
        let res = nf.string(from: NSNumber(1234.02)) ?? ""
        mm_printLog("res->\(res)")
    }
    
    func imgPress() {
        let img = UIImage(named: "每日一句")
        let data = img?.pngData()
//        let data = img.
    }
    
    func deviceInfo() -> Void {
        let device = UIDevice.current
        let name = device.name
        let model = device.model
        var systemInfo: utsname = utsname()
        uname(&systemInfo)
        //第一种方法
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //第二种方法
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
            
//        systemInfo.sysname.withUnsafeBufferPointer { ptr in
//                 let s = String(validatingUTF8: ptr.baseAddress!)
//               print(s)
//        }
//        let machine = String(cString: sname.machine)
//        let machine = String(cString: sname.sysname)
        mm_printLog(identifier)
    }
    
    func jsonTest_1() {
        let path = Bundle.main.path(forResource: "error_result.json", ofType: "")
//        let path = Bundle.main.path(forResource: "result", ofType: "json")
//        let url = URL(string: "null")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!))
//            let json = try JSON(data: data)
//            let typos = try JSONDecoder().decode([Typo].self, from: json["typos"]["typo"].rawData())
            let typos = try JSONDecoder().decode(JPModel.self, from: data)

            mm_printLog(typos)
        } catch(let e) {
            mm_printLog(e)
        }
    }
    
    func deviceTest() {
        let deviceId = genericeDeviceID()
        let sec = genUUID()
        mm_printLog(deviceId)
    }
    func genUUID() -> String {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid) as String
        return uuidString
    }
    
    func genericeDeviceID() -> String {
        var uuid: String? = nil
        #if os(watchOS)
        uuid = genUUID()
        #else
        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            uuid = deviceID
        } else {
            uuid = genUUID()
        }
        #endif
        
        return uuid!
    }
    
    
    func foo() {
        
    }
    var recording: Bool = false
    var recorder: AVAudioRecorder?
    func audioTest_37() {
        if recording {
            mm_printLog("test 结束->")
            recording = false
            recorder?.stop()
            return
        }
        recording = true
        mm_printLog("test 开始->")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            var recordSettings:[String:Any] = [:]
            recordSettings[AVSampleRateKey] = 16000.0
            recordSettings[AVNumberOfChannelsKey] = 1
            recordSettings[AVLinearPCMBitDepthKey] = 16
            recordSettings[AVLinearPCMIsBigEndianKey] = false
            recordSettings[AVLinearPCMIsFloatKey] = false
            //配置的文件路径中的文件夹，必须存在
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0].appendPathComponent(string: "test/test.wav")
            
            let url = URL(fileURLWithPath: path)
            recorder = try AVAudioRecorder(url: url, settings: recordSettings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorder?.record()
        } catch let e {
            mm_printLog(e)
        }
        
    }
    deinit {
        MMDispatchTimer.cancelTimer(timerName: self.timerStr)
    }
}

extension MMFuncTool: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        mm_printLog("test->\(recorder)")
//        let audioAsset = AVURLAsset(url: recorder.url)
//        let audioDuration = audioAsset.duration
//        lastRecordDurationInSeconds = CMTimeGetSeconds(audioDuration)
        UIImagePickerController.InfoKey.editedImage
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        mm_printLog("test-error->\(error)")
    }
        
    //MARK: AvAudioPlayerDelegate
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        mm_printLog("test->\(recorder)")

//        if !callOnFinishPlayBlock(flag) {
//            stopAndCleanPlayerInternal()
//        }
    }
}
extension MMFuncTool {
    func netTest() {
        NetTest().mulitRequest()
    }
}
extension MMFuncTool {
    func rangeTest() {
        //直接crash： Thread 1: Fatal error: Range requires lowerBound <= upperBound
//        let range = 10..<5
        let range = 0..<5
        let range_2 = 5..<10
        
        var v = 10
        //21
        v += 10 + 1
        v = 10
        //-1
        v -= 10 + 1
        v = 10
        //1
        v -= 10 - 1
        mm_printLog("")
        
        MMLocationManager.shared.startOnceLocation { type, item in
            item?.reverseLocation(complete: { success, _item in
                mm_printLog("")
            })
        }
    }
    
    func secretTest() {

        let text = "appid=1657835537language=zh-Hanslocation=WX4FBXXFKE4Ftimestamp=1642663075000unit=c"
        let key = "M5B14dsPBVAjt0p5"
        let r = MMSecret().hmac_sha1(key: key, text: text)
        let r2 = MMSecret().hmac_sha1_2(key: key, text: text)
        mm_printLog(r + r2)
    }
    
    func dateTest() {
        MMDateTest.dateTest()
    }
    
    func voiceTest() {
        MMLocalSpeech.shared.speech(text: "你好你好你好hello word， 温度133°, 适度哈哈哈") {
            mm_printLog("1")
        } completion: {
            mm_printLog("2")
        }       
    }
    
    func test37() {
        let def = UserDefaults.standard
        let allLanguages = def.object(forKey: "AppleLanguages") as! [String]
        //zh-Hans-US 中文，美国， en-US  英文，美国  中文中国 zh-Hans-CN  en-CN(英文中国)
        mm_printLog(allLanguages)
    }
    
    func emptyTest_38() {
        var str: String?
        if str?.isEmpty == true {   // nil == true => false
            mm_printLog("empty_1")
        }
        str = "1"
        if str?.isEmpty == true {  // false
            mm_printLog("empty_2")
        }
        
        mm_printLog("end")
        enumTEst()
    }
    
    func printTest() {
        var typo = Typo.shared
        typo.trans = "test"
        mm_printLog(Typo.shared.trans)
        var typo_2 = Typo.shared
        //10.2%
        let str = String(format: "%.1f%%", 10.23)
        
        let str2 = String(format: "%02d", 1)
        
        let str3 = String(format: "%04d", 1)
        //false
//        let isWord = "abc d".isEnglistWord
        //无论什么情况都会crash
//        fatalError("test")
        mm_printLog(str)
    }
    
    func fontTest() {
        let familyNames = UIFont.familyNames
        mm_printLog(familyNames)
    }
    
    
    func testAnaly() {
//        let path = Bundle.main.path(forResource: "AREACODE", ofType: "txt")!
//        let str = try? String(contentsOfFile: path)
//        let AREACODE = str?.components(separatedBy: "\n") ?? []

        let path_2 = Bundle.main.path(forResource: "city", ofType: "txt")!
        let str_2 = try? String(contentsOfFile: path_2)
        let allcity = str_2?.components(separatedBy: "\n") ?? []
        
        let result = allcity.map { item -> TQCityModel in
            let arr = item.components(separatedBy: " ") //\t
            return TQCityModel(arr: arr)
        }
        
//        let data = try? JSONEncoder().encode(result)
        let savePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let filePath = savePath.appendPathComponent(string: "cityList.plist")
        let url = URL(fileURLWithPath: filePath)
//        do {
//
////            try data?.write(to: url, options: .atomic)
//        } catch let error {
//            mm_printLog(error)
//        }
        
        //读取
//        guard let readData = try? Data(contentsOf: url, options: .alwaysMapped) else { return }
//        let modelArr = try? JSONDecoder().decode([MMCity].self, from: readData)
        mm_printLog(result)
//        mm_printLog(modelArr)
        
    }
    
    func timer() {
//        var count = 0
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
//            mm_printLog("timer->")
//            if count == 30 {
//                timer.invalidate()
//            }
//            count += 1;
//        }
        timerStr = MMDispatchTimer.createTimer(startTime: 1, infiniteInterval: 2, isRepeat: true, async: true) {
            mm_printLog("start->")
        }
    }
    

    func copyTest() {
        var typo = Typo()
        typo.trans = "typo1"
        var typo2 = Typo()
        typo2.trans = "typo2"
        var typo3 = Typo()
        typo3.trans = "typo3"
        var list = [typo, typo2, typo3]
        
        list[1].trans = "typo2_change"
        //typo2_change
        var c_typo2 = list[1]
        
        mm_printLog("")
    }
    
    func attrTest() {
        let attr = NSMutableAttributedString.init(string: "")
        let imgStr = NSAttributedString(string: "test")
        //不会crash
        attr.insert(imgStr, at: 0)
        mm_printLog("")
    }
    
    func enumTEst() {
        let o = EnumTest(rawValue: 4)
        mm_printLog("")
    }
}

enum EnumTest: Int {
    case one = 0
    case two = 1
}
var index: Int = 0
struct TQCityModel: Codable {
    var cityId: String = "北京市"
    //东城区
    var qu: String = "北京市"
    //北京
    var jianCheng: String = "北京"
    var pinyin: String = "Beijing"
    var pinyinLow: String = "beijing"
    
    init(arr: [String]) {
        index += 1
        guard arr.count > 3 else {
            mm_printLog("当前->\(index)")
            return
        }
        cityId = arr[0]
        let guishu = arr[1].components(separatedBy: "/")
        qu = guishu.last ?? ""
        let chengshi = arr[2].components(separatedBy: "/")
        jianCheng = chengshi.last ?? ""
        pinyin = arr[3]
        pinyinLow = pinyin.lowercased()
    }
}

struct MMCity: Codable {
    var cityArea: String = ""
    var cityId: String = ""
    var cityEn: String = ""
    var cityCn: String = ""
    var districtEn: String = ""
    var districtCn: String = ""
    var provEn: String = ""
    var provCn: String = ""
    
    init(arr: [String]) {
        cityArea = arr[0]
        cityId = arr[1]
        cityEn = arr[2]
        cityCn = arr[3]
        districtEn = arr[4]
        districtCn = arr[5]
        provEn = arr[6]
        provCn = arr[7]
    }
}

struct Typo: Codable {
    public var word: String?
    public var trans: String?
    
    var textV: String?
    
    static var shared: Typo = Typo()
    //会失败
//    var text_b: String = ""
}


class JPModel: Codable {
    var input: String?
    var le: String?
    var lang: String?
    
}
extension MMFuncTool {
 
}


protocol MMEmptyProtocol {
    func testPrint()
}

extension MMEmptyProtocol {
    func testPrint() {
        mm_printLog(self)
//        #define PTHREAD_MUTEX_NORMAL        0
//        #define PTHREAD_MUTEX_ERRORCHECK    1
//        #define PTHREAD_MUTEX_RECURSIVE        2
//        #define PTHREAD_MUTEX_DEFAULT        PTHREAD_MUTEX_NORMAL
//        var mutex_lock: pthread_mutex_t/
//        var mutex_attr: pthread_mutexattr_t
//
//        pthread_mutexattr_init(&mutex_attr)
//        pthread_mutexattr_settype(&mutex_attr, PTHREAD_MUTEX_NORMAL)
//        pthread_mutex_init(&mutex_lock, &mutex_attr)
        
    }
    
    func testPrint2() {
        mm_printLog("222")
    }
    
    func testPrint3() {
        mm_printLog("333")
    }
}

extension MMFuncTool: MMEmptyProtocol {
    func testPrint2() {
        mm_printLog("111")
    }
}

extension FuncTestVC: MMEmptyProtocol {}


