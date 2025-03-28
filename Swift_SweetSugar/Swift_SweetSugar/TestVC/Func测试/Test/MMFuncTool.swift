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
import NaturalLanguage
import CoreMotion
import Toaster

enum MMTest {
    case one
    case two
    case three
}

class MMFuncTool: NSObject {
    
    lazy var blockClass: MMBlockClass = {
        let item = MMBlockClass()
        return item
    }()
    
    lazy var blockClass2: MMBlockClass2 = {
        let item = MMBlockClass2()
        return item
    }()
    
    lazy var player: MMAudioTool = {
        let item = MMAudioTool()
        return item
    }()
    
    private var observer: NSObjectProtocol?

    func urltest_17_1() -> Void {
        // 不会crash
        let url = URL(string: "null")!
        // 会crash
        let url2 = URL(string: "")!
        print("test->test")
    }
    func urltest_17() -> Void {
        urltest_17_1()
        return;
        let urlStr = "https://shared.youdao.com/dict/market/living-study-ranking-test/index.html#/?hide-toolbar=true"
//        let urlStr_2 = "https://shared.youdao.com/dict/market/training-camp-test/index.html/campDetails"
        let urlStr_3 = "https://shared.youdao.com/dict/market/living-study-ranking-test?hide-toolbar=true/#/"
        
        let urlStr_4 = "https://hiecho.youdao.com/?t=1702628402#/web?from=cidian_czgn&noCache=true"
    
        let urlStr_5 = "https://shared.youdao.com/dict/market/living-study-ranking/#/?liveRoomId=63423275&userId=lunatest20%40163.com&full-screen=true&authorName=%E6%9C%89%E9%81%93%E8%87%AA%E4%B9%A0%E5%AE%A4&hide-toolbar=true&authorId=urs-phoneyd.dae58a7b75ec4299a%40163.com&t=1713421573465"
        
        let urlStr_6 = "https://shared.youdao.com/dict?t=1713421573465#/"

        let urlStr_7_1 = "https://c.youdao.com/dict/miniprogram/japanese50.html#/index?keyfrom=doc&topIndex=0"
        let urlStr_8 = "https://shared.youdao.com/dict/market/dict-examv7/#/?level=%E5%9B%9B%E7%BA%A7"
        let urlStr_9 = "https://shared.youdao.com/dict/market/living-study-ranking/#/?keyfrom=doc"
        let urlStr_10 = "https://reg.163.com/naq/findPassword#/verifyAccount"
        let urlStr_11 = "https://shared.youdao.com/dict/market/global-pronounce-list-test/?timestamp=1715238322671#/?rankType=total&topIndex=0&word=hello&hide-toolbar=true&full-screen=true&adjustSafeArea="
        
        let url_12 = "localDefault://ydlunacommon-cdn.nosdn.127.net/913a2f38efd21e0acd8fabced4b21a5f.png?imageView=&type=webp"
        let url_13 = URL.init(string: url_12)
        
    
    
//        let encode_url = urlStr.urlEncoded()
//        
        let component = URLComponents(string: urlStr)
//        var component_2 = URLComponents(string: urlStr_2)
//        
//        component_2?.queryItems?.append(URLQueryItem(name: "name", value: "test"))
//        
        let component_3 = URLComponents(string: urlStr_3)
//
        let component_4 = URLComponents(string: urlStr_4)

        let encode_url = urlStr_5.urlEncoded()
        
        let component_5 = URLComponents(string: urlStr_11)
        
//        let charSet = CharacterSet.urlQueryAllowed
//        
//        let url = URL(string: urlStr)
        mm_printLog("test->1")
//        
//        let params: [String: String] = [
//            "goodInfo": "{dsdfsdf}",
//            "nickname": "{dsdfsdf}",
//            "avatar": "{dsdfsdf}",
//            "userId": "{dsdfsdf}",
//        ]
//        let paramsStr = params.map { key, value in
//            return "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//        }.joined(separator: "&")
//        
//        let urlStr_4 = "http://baidu.com?" + paramsStr
//        
//        let url_2 = URL(string: urlStr_4)
//
        mm_printLog("tset->")
//        let urlStr_5 = "https://shared.youdao.com/dict/market/shop-window-test/?noShare=true&full-screen=true&adjustSafeArea=true&hide-toolbar=true&hide-toolbar=true&postType=VIDEO&avatar=https%3A%2F%2Fydlunacommon-cdn.nosdn.127.net%2F9ea7678834227363caeb05dd1d9e99cc.png&nickname=urs%2A%2A%2A%2A%2A%2Acom&userId=urs-phoneyd.cda14678cacf43fea%40163.com&goodInfo=%7B%22id%22%3A3908%2C%22category%22%3A33%2C%22backupLandingPageUrl%22%3A%22https%3A%5C%2F%5C%2Fwww.baidu.com%5C%2F%22%2C%22schemaId%22%3A3%2C%22activeClosed%22%3Afalse%2C%22itemPrice%22%3A10000%2C%22promotionType%22%3A2%2C%22buttonText%22%3A%22%E8%B4%AD%E4%B9%B0%22%2C%22itemName%22%3A%22deeplink%E5%BC%95%E5%AF%BC%E6%96%87%E6%A1%88%22%2C%22source%22%3A0%2C%22switchType%22%3A2%2C%22componentId%22%3A%22dAYwySUtbY%22%2C%22promoteImageUrl%22%3A%22http%3A%5C%2F%5C%2Foimagec4.ydstatic.com%5C%2Fimage%3Fid%3D4030997507705062280%26product%3Dadpublish%26format%3DJPEG%22%2C%22strikeThroughPrice%22%3A10000%2C%22leadText%22%3A%22deeplink%E5%BC%95%E5%AF%BC%E6%96%87%E6%A1%88%22%2C%22markAsAd%22%3Atrue%2C%22name%22%3A%22deeplin%22%2C%22deepLink%22%3A%22bilibili%3A%5C%2F%5C%2Fsearch%5C%2F%25E8%2580%2583%25E7%25A0%2594%3Fh5awaken%3Db3Blbl9hcHBfZnJvbV90eXBlPWRlZXBsaW5rX21hcmtldGluZy1rYW95YW4mb3Blbl9hcHBfdXJsPXNlYXJjaC1rYW95YW4tMQ%3D%3D%22%7D#/more"
//        let url_3 = URL(string: urlStr_5)
//        let com = URLComponents(string: urlStr_5)
//        
//        let urlStr_6 = "https://shared.youdao.com/dict/market/living-study-ranking-test/?t=1668069073944&authorId=urs-phoneyd.688d91f7dca547289%40163.com&hide-toolbar=true&userId=course_test%40163.com&liveRoomId=34511893&authorName=%E4%BB%8A%E5%A4%A9%E4%B9%9F%E8%A6%81%E5%A5%BD%E5%A5%BD%E5%8A%AA%E5%8A%9B%E5%91%80&full-screen=true"
//        let url_4 = URL(string: urlStr_6)
//        
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
    }

    
    func jsonTest_31() {
        let str = "{\"msgID\":\"1478746890721\",\"title\":\"push_update\",\"type\":\"notice\",\"url\":\"yddict://youdao.com/guidingpage?liveRoomId=123122312\"}"
        let json = JSON.init(parseJSON: str)
        
        let arrJson = JSON.init([])
        if arrJson.type == .array {
            let item = arrJson[0]
            mm_printLog("test->1")
        }
        let str_2 = ""
        mm_printLog("test->")
    }
    
    func memoryTest_56() {
        var block = {
            for i in 0...100000 {
                autoreleasepool {
                    // string 大概才会增加10m内存
//                    let str = "helloword test: \(i)"
//                    let str_2 = "helloword test2 : \(i)"
                    // obj会增加180M内存
                    let obj = MMNSObject()
                    let obj2 = MMNSObject()
                }
            }
            print("test->finishED:")
        }
//        block()
        
        DispatchQueue.global().async {
            block()
        }
    }
    
    var timerStr: String?
    var timer: Timer?

    func PasteboardTest_26() {
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
    
    lazy var downloader = ImageDownloader()
    func operationQueueTest() {
//        let operation = Operation()
//        operation.completionBlock = {
//            mm_printLog("finished")
//        }
//        OperationQueue.main.addOperation(operation)
//        
//        MMFuncTool.add(a: 1, b: 3) { result in
//            mm_printLog(result)
//        }
//        mm_printLog("before wait")
//        // 主线程执行会卡死主线程
////        OperationQueue.main.waitUntilAllOperationsAreFinished()
//        mm_printLog("wait")
        
//        downloadImages()
        // 完美
//        downloader.downloadImages()
        downloader.downloadImages_OperationQueue()

    }
    
    func naviTest() {
        guard let nav = UIViewController.currentViewController()?.navigationController,
                  var viewcontrollers = UIViewController.currentViewController()?.navigationController?.viewControllers else { return }
        viewcontrollers.removeLast()
        viewcontrollers.append(UITestVC())
        nav.setViewControllers(viewcontrollers, animated: true)
    }
    
    static func add(a: Int, b: Int, block: @escaping ((Int) -> Void)) {
        OperationQueue.main.addOperation {
            block(a + b)
        }
    }
    
    // 主函数
    func downloadImages() {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        let completionOperation = BlockOperation {
            // 所有图片下载完成后的回调
            print("All images downloaded!")
        }

        // 生成100个下载操作，并添加到队列
        for i in 1...10000 {
            if let imageURL = URL(string: "https://example.com/image\(i).jpg") {
//                let downloadOperation = ImageDownloadOperation(imageURL: imageURL)
                
                let downloadOperation = Operation()
                downloadOperation.completionBlock = {
                    mm_printLog("下载: \(i), \(Thread.current)")
                }
                // 将下载操作添加到 completionOperation 的依赖中
                completionOperation.addDependency(downloadOperation)

                // 添加操作到队列
                operationQueue.addOperation(downloadOperation)
            }
        }

        // 将 completionOperation 添加到队列
        operationQueue.addOperation(completionOperation)
        mm_printLog("before wait")

        // 等待队列中的所有操作完成
//        operationQueue.waitUntilAllOperationsAreFinished()
        
//        mm_printLog("wait")

    }

    var testBlock4: ((MMFuncTool) -> Void)?
    /// weakTest 循环引用测试
    /// - Parameter vc: 测试
    func blockTest(vc: FuncTestVC) {
//        blockDemoFunc { [weak self, weak vc] tool, vc in
//            
//        }
//      //隐士捕获
        var testStr: String = ""
        let testBlock: (String) -> Void = { str in
            testStr += str
            print("test->testStr:\(testStr)")
        }
        testStr = "test"
        testBlock("good")
        // test->testStr:testgood
        print("test->testStr:\(testStr)")
        // 捕获列表
        let testBlock2: (String) -> Void = { [_testStr = testStr] str in
            // test->_testStr:testgood, str: good2
            print("test->_testStr:\(_testStr), str: \(str)")
        }
        testStr = "test2"
        testBlock2("good2")
        // 弱引用捕获
        
        
        let testBlock4: (MMFuncTool) -> Void = { (tool) in
            print("test->---------------:\(tool)--")
        }
        self.testBlock4 = testBlock4
        testBlock4(self)
        print("test->------------------")
        // 不会循环引用
//        blockClass.block1 = { [weak self] in
//            print("test->测试持有self1:\(self)")
//            DispatchQueue.main.async {
//                print("test->测试持有self2:\(self)")
//            }
//        }
        
        // 会循环引用
//        blockClass.block1 = {
//            print("test->测试持有self1:\(self)")
//            DispatchQueue.main.async {
//                print("test->测试持有self2:\(self)")
//                self.blockClass2.block1 = {
//                    print("test->测试持有self2:\(self)")
//                }
//            }
//        }
//        // 跟调用有关系
//        blockClass.block1?()
        
        // 不会循环引用： 不论 blockClass.block1?() 是否调用
//        blockClass.block1 = { [weak self] in
//            print("test->测试持有self1:\(self)")
//            self?.blockClass2.block1 = {
//                print("test->测试持有self2:\(self)")
//            }
//            // 跟下面block调用也没有关系
//            self?.blockClass2.block1?()
//        }
//        blockClass.block1?()
        
        // 会循环引用: 在调用 blockClass.block1?() 时。
//        blockClass.block1 = { [weak self] in
//            guard let self = self else { return }
//            print("test->测试持有self1:\(self)")
//            self.blockClass2.block1 = {
//                print("test->测试持有self2:\(self)")
//            }
//            // 跟下面block调用没有关系
//            self.blockClass2.block1?()
//        }
        // 跟下面block调用有关系
//        blockClass.block1?()
        
        
        // 会循环引用
//        blockClass.block1 = {
//            print("test->测试持有self1:")
//            MMCommonShare.shareInstance.blockClass2.block1 = { [weak self] in
//                guard let self = self else { return }
//                print("test->测试持有self2:\(self)")
//            }
//            // 跟下面block调用没有关系
//            // MMCommonShare.shareInstance.blockClass2.block1?()
//        }
//        // 跟下面block调用有关系
//        blockClass.block1?()
        
        // 不会循环引用
//        blockClass.block1 = { [weak self] in
//            print("test->测试持有self1:")
//            MMCommonShare.shareInstance.blockClass2.block1 = { [weak self] in
//                guard let self = self else { return }
//                print("test->测试持有self2:\(self)")
//            }
//            // 跟下面block调用没有关系
//            // MMCommonShare.shareInstance.blockClass2.block1?()
//        }
//        // 跟下面block调用没有关系
//        blockClass.block1?()
        
        
        // 不会循环引用 不论 blockClass.block1?() 是否调用
//        self.blockClass.block1 = { [weak self] in
//            guard let self = self else { return }
//            print("test->测试持有self1:\(self)")
//            self.blockClass2.block1 = { [weak self] in
//                print("test->测试持有self2:\(self.blockClass)")
//                
//            }
//            // 跟下面block调用也没有关系
//            self.blockClass2.block1?()
//        }
//        //跟下面block调用也没有关系
//        blockClass.block1?()
        
        // 不会循环引用
//        blockClass.block1 = { [weak self] in
//            guard let self = self else { return }
//            print("test->测试持有self1:\(self)")
//            DispatchQueue.main.safeAsync {
//                print("test->测试持有self2:\(self)")
//            }
//        }
////        跟下面block调用也没有关系
//        blockClass.block1?()
        
        print("test->调用完成")
    }
    
    func blockDemoFunc(b: ((_ tool: MMFuncTool,_ vc: FuncTestVC) -> Void)) {
    
    }
    
    /// 自然语言测试 Natural Language
    func nlTest_47() {
        //韩 英 中
//        let text = "안녕하세요 hello world 你好"
        //英 日 日 日
//        let text = "Hello, world! 你好！ こんにちは！ 这是一段中文"
        let text = """
这段话有两个错误：
1. 在第二句话中，"has not spoken" 应该改为 "did not speak"，因为这里是过去的事件，使用过去时态更合适。
2. 在第三句话中，"had previously told" 应该改为 "previously told"，因为这里是连续发生的过去事件，没有必要使用过去完成时。

修改建议：
1. 将 "has not spoken" 改为 "did not speak"，因为这里是过去的事件，使用过去时态更合适。
2. 将 "had previously told" 改为 "previously told"，因为这里是连续发生的过去事件，没有必要使用过去完成时。

修改结果：
After apologising, Mr Musk said that Mr Thorleifsson was considering coming back to Twitter. The BBC did not speak to Mr Thorleifsson since Mr Musk's apology. Mr Thorleifsson previously told the BBC the situation was "strange" and "extremely stressful".
"""

        let date = Date().timeIntervalSince1970
        let tagger = NLTagger(tagSchemes: [.language])
        tagger.string = text
        
        var langMap: [String: String] = [:]
        let range = text.startIndex..<text.endIndex
        var count = 0
        //当为 paragraph 和 sentence时 options不能含有 omitOther， 因为会把标点符号省略。
        tagger.enumerateTags(in: range, unit: .word, scheme: .language, options: [.omitWhitespace, .omitPunctuation, .omitOther]) { tag, tokenRange in
            if let languageCode = tag?.rawValue {
                let language = Locale.current.localizedString(forIdentifier: languageCode)
                print("Detected language: \(language ?? "Unknown") for text: \(text[tokenRange])")
                
                if let _ = langMap[languageCode] {
                    
                } else {
                    langMap[languageCode] = language
                }
                
            }
            count += 1
            mm_printLog("检测到语种 循环中- for text: \(text[tokenRange])")
            return true
        }
        //word 检测到语种 语言结果:[\"zh-Hans\": \"Chinese, Simplified\", \"en\": \"English\"], 文本长度:569, 检测耗时:0.04100990295410156 循环检测次数: 149"
        //sentence 检测到语种 语言结果:[\"en\": \"English\", \"zh-Hans\": \"Chinese, Simplified\"], 文本长度:569, 检测耗时:0.02654099464416504" 循环检测次数 16次
        //paragraph 检测到语种 语言结果:[\"zh-Hans\": \"Chinese, Simplified\", \"en\": \"English\"], 文本长度:569, 检测耗时:0.020205974578857422 循环检测次数: 10"
        mm_printLog("检测到语种 语言结果:\(langMap), 文本长度:\(text.count), 检测耗时:\(Date().timeIntervalSince1970 - date) 循环检测次数: \(count)")
        nlTest2(text: text)
        
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        if let language = recognizer.dominantLanguage {
            print("test->\(language.rawValue)")  // en
        } else {
            print("Language not recognized")
        }
        
        // Generate up to two language hypotheses. 生成最多两种语言假设
        let hypotheses = recognizer.languageHypotheses(withMaximum: 2)
        print(hypotheses)   // [__C.NLLanguage(_rawValue: de): 0.43922990560531616, __C.NLLanguage(_rawValue: en): 0.5024932026863098]
        
        recognizer.reset()
        // Specify constraints for language identification. 为语言识别指定约束。
        recognizer.languageConstraints = [.french, .english, .german,
                                          .italian, .spanish, .portuguese, .simplifiedChinese]
        // 限制语言的概率
        recognizer.languageHints = [.french: 0.5,
                                    .simplifiedChinese: 0.9,
                                    .english: 0.9,
                                    .german: 0.8,
                                    .italian: 0.6,
                                    .spanish: 0.3,
                                    .portuguese: 0.2]
        
        let constrainedHypotheses = recognizer.languageHypotheses(withMaximum: 2)
        print(constrainedHypotheses)
        
        // Reset the recognizer to its initial state.  重置（如果需要继续识别的话）
        // Process additional strings for language identification.
        recognizer.processString("重置（如果需要继续识别的话）")
//        recognizer.processString(text)
        // Generate up to two language hypotheses. 生成最多两种语言假设
        let hypotheses_2 = recognizer.languageHypotheses(withMaximum: 2)
        print("test->hoy: \(hypotheses_2)")   // [__C.NLLanguage(_rawValue: es): 0.9999449253082275, __C.NLLanguage(_rawValue: pt): 2.7900192435481586e-05]
        
    }
    
    func nlTest2(text: String) {
//        let string = "안녕하세요"
        let date = Date().timeIntervalSince1970
        let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
        tagger.string = text
        var count = 0
        var langMap: [String: String] = [:]
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .language, options: [.omitWhitespace, .omitPunctuation, .omitOther]) { tag, range, stop in
            count += 1
            mm_printLog("检测到语种 循环中- for text: \(text[Range(range)!])")
            guard let languageCode = tag?.rawValue else { return }
            let language = Locale.current.localizedString(forIdentifier: languageCode)
            print(language ?? "Unknown language")
            if langMap[languageCode] == nil {
                langMap[languageCode] = language
            }
            if langMap.count > 2 {
                stop.pointee = false
            }
        }
        //是否1个
        //两个是否是 zh-CHS, en
        mm_printLog("检测到语种 语言结果:\(langMap), 文本长度:\(text.count), 检测耗时:\(Date().timeIntervalSince1970 - date) 循环检测次数: \(count)")
    }
    
//    var dataArray: [Data] = [Data]()
    var dataArray: [String] = [String]()

    
    let backQueue = DispatchQueue(label: "com.mumu.back", attributes: .concurrent)
    let backQueue2 = DispatchQueue(label: "com.mumu.back_2", attributes: .concurrent)
    func arrayTest_27() -> Void {
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
        removeTest()
        
        let item1 = MMSortItem(couponPrice: 10, expiredTime: 3)
        let item2 = MMSortItem(couponPrice: 10, expiredTime: 5)
        let item3 = MMSortItem(couponPrice: 9, expiredTime: 3)
        let item4 = MMSortItem(couponPrice: 3, expiredTime: 3)
        var arr = [item1, item2, item3, item4]

        let maxConcup = arr.max { left, right in
            if left.couponPrice == right.couponPrice {
                // 取小的
                return (left.expiredTime ?? 1) > (right.expiredTime ?? 0)
            }
            // 取大的
            return (left.couponPrice ?? 0) < (right.couponPrice ?? 1)
        }
        
        var toolStrArr: [String] = ["0","1","2","3","4"]
        //"0,1,2,3,4"
        let joinStr = toolStrArr.joined(separator: ",")
        
        //找出元素的index
        switch toolStrArr.firstIndex(of: "four") {
        case let idx?:
            toolStrArr.remove(at: idx)
        case nil:
            break // 什么都不做
        }
        
        // 并不影响原数组
        let resultArr = toolStrArr.dropFirst()
        print("test->toolStr:\(toolStrArr)")
        
        let arr2 = MMCustomOCObj().createNSArray()
        print("test->arr:\(arr2)")
        let resultArr2 = arr.dropFirst()
        print("test->resultArr2:\(resultArr2)")

        
        var toolArr: [Int] = [0,1,2,3,4,5]
        var toolOptionStrArr: [String?] = ["0","1","str","3"]

 
        
        
        var emptyArray: [Int] = []
        // 不会崩
        emptyArray.insert(contentsOf: toolArr, at: 0)
        
        //17 -> 2 + 0 + 1 + 2 + 3 + 4 + 5
        let r1 = toolArr.reduce(2) { partialResult, item in
            return partialResult + item
        }
        //result->01234  累加
        let r2 = toolStrArr.reduce("result->") { partialResult, item in
            return partialResult + item
        }
        
        let r2_1 = toolArr.reduce(+)
        let r2_2 = toolArr.reduce_alt(+)

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
        if let model: MMSimpleStruct = nil {
            mm_printLog("不会走")
        }
        // 不会crash, 插入成功
        emptyArr.insert(0, at: 0)
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
        
        let range = 0..<10
        let create_1 = Array(0..<10)
        mm_printLog(create_1)
    }
    
    func removeTest() {
        var toolStrArr: [String] = ["0","1","2","3","4"]
        if toolStrArr.count > 4 {
            toolStrArr.remove(at: 4)
            toolStrArr.insert("5", at: 4)
            print("test->arr:\(toolStrArr)")
        } else {
            print("test->个数不对:")
        }
    }
    
    func dictTest() {
        let frequencies = "hello".frequencies // ["o": 1, "h": 1, "e": 1, "l": 2]
        frequencies.filter { $0.value > 1 } // ["l": 2]
        "".index(after: "".startIndex)
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
        
        let price1 = Decimal(0.0)
        // 使用错误
        let price2 = Decimal(4980.99)
        let price3 = price1 + price2
        // 使用正确: 需要
        let price4 = Decimal(string: "4980.99") ?? 0
        let price5 = price1 + price4
        mm_printLog("res->\(price3)")

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
        // 3AA4AD73-6082-467B-B7E1-F1AD84CF0246:
        let deviceId = genericeDeviceID()
        //  5BDDA66F-4130-45A1-8B85-65F612708B84
        let sec = genUUID()
        mm_printLog("test->deviceId: \(deviceId), sec: \(sec)")
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
//        NotificationCenter.default.addObserver(self, selector: #selector(handleNotify(sender:)), name: AVAudioSession.routeChangeNotification, object: nil)

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
    
    var observation: NSKeyValueObservation?
    var stateObservation: NSKeyValueObservation?
    var vcObservation: NSKeyValueObservation?
    var claObservation: NSKeyValueObservation?

    @objc dynamic var state: PlayState = .play
    // 2. 使用`@objc dynamic`修饰符定义属性。
//    @objc dynamic var myEnum: MyClass.MyEnum = .first
    
    private var myObject: MyClass = MyClass()
    
    /// 必须使用 @objc dynamic
    @objc dynamic private var myObject_2: MyClass = MyClass()

    @objc dynamic var kvoStr: String = "test"
    
    func kvoTest_48(vc: FuncTestVC) {
        // 监听有效
        stateObservation = observe(\.state, options: [.old, .new]) { object, change in
            mm_printLog("test->stateChange:\(change.oldValue), \(change.newValue)")
        }
        // 监听有效 3. 在需要监听属性的类中，使用KVO来监听属性的更改。
        observation = self.myObject.observe(\.myEnumNumber, options: [.new]) { (object, change) in
            guard let newValue = change.newValue else { return }
            print("observation value changed to: \(newValue)")
        }
        // 监听有效
        vcObservation = vc.observe(\.obStr, options: [.new]) { obVC, change in
            guard let newValue = change.newValue else { return }
            print("Enum value changed to: \(newValue)")
        }
        
        // 监听有效
        claObservation = observe(\.myObject_2, options: [.old, .new], changeHandler: { object, change in
            guard let newValue = change.newValue else { return }
            print("claObservation value changed to: \(newValue)")
        })
        
        addObserver(self, forKeyPath: "kvoStr", options: [.new, .old], context: nil)
        // 注册对 person.name 属性的观察，传递新值和旧值，使用 KeyPath 类型
//self.addObserver(self, forKeyPath: \MMFuncTool.kvoStr, options: [.new, .old], context: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            print("test->变更: myObject")
            vc.obStr = "改变新的"
            self.state = .pause
            self.myObject.myEnum = .second
            self.kvoStr = "变更"
            print("test->变更: myObject end")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            print("test->变更:myObject_2")
            self.myObject_2 = MyClass()
            print("test->变更:myObject_2  end")
        }
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) { [weak self] in
//            guard let self = self else { return }
//            self.state = .pause
//            self.myObject.myEnum = .second
//            self.myObject.myEnum = .third
//        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath else { return }
        print("test->鉴定到kvo: \(keyPath)")
        print("test->鉴定到kvo2: \(String(describing: change))")

    }
    
    deinit {
        MMDispatchTimer.cancelTimer(timerName: self.timerStr)
        timer?.invalidate()
        timer = nil
        observation?.invalidate()
        stateObservation?.invalidate()
        claObservation?.invalidate()
        vcObservation?.invalidate()
        mm_printLog("释放")
    }

    
    var window: UIWindow?
    var vc: MMSplashViewController?
    
    var stop: Bool = false
    var stopCount: Int = 0

}

extension MMFuncTool {
    

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
    func netTest_39() {
//        NetTest().mulitRequest()
        // 下载测试
//        MMNetWorkManager.shared.request()
        // 音频播放
        AudioPlayerManager.shared.fetchAndPlay()
        
        let a = 10
        let b = 20
        // a + b = sum
    }
    
    func crashTest_41() {
//        let mainOp = OperationQueue.main
//        mainOp.addOperation {
//            mm_printLog(self)
//        }
        
//        let arr = ["test"]
        
//        print("test->crash:\(arr[1])")
//        let err_1 = NSError(domain: "", code: -999)
//        let err_2 = NSError()

//        obj.asserttest()
//        obj.notImplMethod()
//        obj.receiveError(err_1)
//        obj.receiveError(err_2)
//        _sendError(error: err_2)
        
//        blockCrashTest()
        // 现在这里注释
//        stopCount = 0
//        NotificationCenter.default.addObserver(self, selector: #selector(removeSplash), name: Notification.Name(rawValue: "dismissVC"), object: nil)
//        cmmotionManagerCrash()
        
//        crash_test41_2()
        crash_threadSafe()
    }
    
    func cmmotionManagerCrash() {
        self.window = nil
        print("test->释放widdow:")
        let _window = UIWindow(frame: UIScreen.main.bounds)
        self.window = _window
        vc = MMSplashViewController.init()
        
        window?.rootViewController = vc
        window?.isHidden = false
        
        guard stopCount < 5 else {
            removeSplash()
            return
        }
        self.stopCount += 1
        print("test->crash: 开始5秒倒计时")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("test->crash: stopAccelerometerUpdates")
            self.cmmotionManagerCrash()
//            self.motionManager.stopAccelerometerUpdates()
        }
    }
    
    @objc func removeSplash() {
        self.window = nil
        print("test->释放widdow:2")
    }
    
    func blockCrashTest() {
        let obj = MMCustomOCObj()
        if obj.emptyBlock != nil {
            obj.emptyBlock?()
        }
        obj.emptyBlock?()
        obj.callBlock()
    }
    
    func _sendError(error: Error) {
        
        let str = String(reflecting: type(of: error))
        var _ocError = error
        if (error as? NSError)?.domain.isEmpty == true {
            _ocError = NSError(domain: "didFailToRegisterForRemoteNotifications", code: -999) 
        }
//        let str = e.localizedDescription ?? ""
        MMCustomOCObj().receiveError(_ocError)
    }
    
    
    //结构体测试
    func structTest_42() {
//        var arr:[MMSimpleStruct] = []
        var model_1 = MMSimpleStruct()
//        arr.append(model_1)
        model_1.name = "test"
        //并不影响数组内的结构体数据
        
        var c_1 = MMSimpleClass()
        c_1.s = model_1
        model_1.c = c_1
        
        mm_printLog(c_1)
        return;
        var model_2 = model_1
        
        withUnsafePointer(to: &model_1) { pointer in
            let address = UnsafeRawPointer(pointer)
            // 0x00000003059b7fb0
            print("Address of model_1 instance: \(address)")
        }
        mm_printLog("szie1: \(MemoryLayout.size(ofValue: model_1))")
        mm_printLog("szie2: \(MemoryLayout.size(ofValue: model_2))")

        withUnsafePointer(to: &model_2) { pointer in
            let address = UnsafeRawPointer(pointer)
            // 0x00000003059b7f70
            print("Address of model_2 instance: \(address)")
        }
        model_2.name = "test2"
        // 不影响model_1的值
        mm_printLog(model_1)
        
        var typo = Typo()
        typo.trans = "typo1"
        var typo2 = Typo()
        typo2.trans = "typo2"
        var list = [typo, typo2]
        
        list[1].trans = "typo2_change"
        //typo2_change
        var c_typo2 = list[1]
        mm_printLog("typo2_change")
    }
    
    func stringTest_50() {
        let str = "test str"
        let md5_1 = str.MD5String
        let md5_2 = str.md5_old
        let md5_3 = str.md5_new
        // c6a8c84908efe116df536993e4543fe4 结果一致
        
        let multiplier = 3
        let message = "(multiplier) times 2.5 is (Double(multiplier) * 2.5)"
        
        mm_printLog("test->")
        stringTest_50_2()
        
        var str_1: String? = nil
        // 只有当str_1 有值是才会赋值成功
        str_1? = "test"
        // 无条件赋值
//        str_1 = "word"
        mm_printLog("test-> str_1: \(String(describing: str_1))")

        let price: Double = 0.0001
        let priceStr = String(format: "￥%.2f", price)
        mm_printLog("test->\(priceStr)")
    }
    
    func stringTest_50_2() -> Void {
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
    
    /// 录屏
    func recordScreenTest_51() {
        let replayTool: MMReplayTool = MMReplayTool.shared
        if replayTool.isRecord {
            replayTool.stopRecording()
        } else {
            replayTool.startRecording()
        }
    }
    
    /// 系统通知周期
    func sysNotifyTest_52() {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.willResignActiveNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.willEnterForegroundNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.willTerminateNotification, object: nil)
        
        // 重复添加，会接收N条通知
        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSysNotify(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func handleSysNotify(sender: Notification) {
        mm_printLog("test->\(sender.name)")
    }
    
    
    /// https://juejin.cn/post/6844903682320891912
    func addSIRITest_57() {
        let activity = NSUserActivity(activityType: "com.AppCoda.SiriSortcuts.sayHi") // 1
        activity.title = "Say Hi" // 2
        activity.userInfo = ["speech" : "hi"] // 3
        activity.isEligibleForSearch = true // 4
        activity.isEligibleForPrediction = true // 5
        activity.persistentIdentifier = NSUserActivityPersistentIdentifier("com.AppCoda.SiriSortcuts.sayHi") // 6
        UIViewController.currentViewController()?.view.userActivity = activity
//        view.userActivity = activity // 7
        activity.becomeCurrent() // 8
        
    }
    // check error
    public func sayHi() {
        let alert = UIAlertController(title: "Hi There!", message: "Hey there! Glad to see you got this working!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        UIViewController.currentViewController()?.present(alert, animated: true, completion: nil)
        
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
        
        let arr = [0, 1, 2, 3, 4]
        for item in 0...0 {
            mm_printLog("test")
        }
        MMLocationManager.shared.startOnceLocation { type, item in
            item?.reverseLocation(complete: { success, _item in
                mm_printLog("")
            })
        }
        
        let str = "1234567890"
        let range_3 = str.mm_nsRangeOfString(str: "0")
        let isContain = range_3.contains(str.count)
        let isContain_2 = range_3.contains(str.count - 1)
        mm_printLog("")
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
    
    func localeTest() {
        let sys = Locale.current
        let cur = Locale.current
    }
    
    func voiceTest() {
        MMLocalSpeech.shared.speech(text: "你好你好你好hello word， 温度133°, 适度哈哈哈") {
            mm_printLog("1")
        } completion: {
            mm_printLog("2")
        }       
    }
    
    func userDefaultTest37() {
        let def = UserDefaults.standard
        let allLanguages = def.object(forKey: "AppleLanguages") as! [String]
        //zh-Hans-US 中文，美国， en-US  英文，美国  中文中国 zh-Hans-CN  en-CN(英文中国)
        mm_printLog(allLanguages)
        
        
        let key = "test_key"
        UserDefaults.standard.set("test", forKey: key)
        //str = "test"
        let str = UserDefaults.standard.string(forKey: key)
        // int_v = 0
        var int_v = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(10, forKey: key)
        //int_v = 10
        int_v = UserDefaults.standard.integer(forKey: key)
        print("test_print")
        
        var cacheDict: [String: Any] = [:]
        cacheDict["id"] = "123456"
        cacheDict["date"] = NSDate()
        UserDefaults.standard.setValue(cacheDict, forKey: "cacheDictKey")
        
        let dict = UserDefaults.standard.dictionary(forKey: "cacheDictKey")
        mm_printLog("test->\(dict)")
    }

    func test46() {
        let arr = MMTool.getAllPropertys(clsName: self)
        let arr2 = MMTool.getAllIvarList(clsName: Self.self)
        mm_printLog("end")
        
    }
    
    func readPlistAndSaveChineseNames() {
        // 获取 plist 文件路径
        guard let plistPath = Bundle.main.path(forResource: "LanguageDictForTransTab", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: plistPath) as? [String: Any] else {
            print("无法找到或加载 plist 文件")
            return
        }
        
        // 遍历并提取 ChineseName 的值
        var chineseNames: [String] = []
        for (_, value) in dictionary {
            if let dict = value as? [String: Any],
               let chineseName = dict["ChineseName"] as? String {
                chineseNames.append(chineseName)
            }
        }
        
        // 将数组保存到 Mac 的文件路径
//        let desktopPath = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
//        let outputPath = desktopPath.appendingPathComponent("ChineseNames.txt")
        let outputPath = URL(fileURLWithPath: "/Users/yangjie01/Downloads/ChineseNames.txt")
        
        do {
            let content = chineseNames.joined(separator: "\n") // 将数组拼接成字符串（换行分隔）
            try content.write(to: outputPath, atomically: true, encoding: .utf8)
            print("成功将 ChineseName 保存到文件：\(outputPath.path)")
        } catch {
            print("保存文件时发生错误：\(error)")
        }
    }

    func regionCodeTest() {
        let code = Locale.current.regionCode
        print("test->code: \(code)")
        
        if let currentLanguage = Locale.preferredLanguages.first {
                // 判断语言是否以 "en" 开头（英文）
                let bool = currentLanguage.starts(with: "en")
            print("test->currentLanguage: \(currentLanguage)")

        }
        print("test-> end")

    }

    func printTest() {
        regionCodeTest()
        return;
        // 调用函数
//        readPlistAndSaveChineseNames()
        
        var typo = Typo.shared
        typo.trans = "test"
        mm_printLog(Typo.shared.trans)
        var typo_2 = Typo.shared
        //10.2%
        let str = String(format: "%.1f%%", 10.23)
        
        let str2 = String(format: "%02d", 1)
        
        let str3 = String(format: "%04d", 1)
        
        
        let f1: Double = 168.10
        let f2: Double = 168.000

        // 168.100
        let str4 = String(format: "%.3f", f1)
        
        let yourDoubleValue = 123.45600 // 替换为你的 Double 值

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = Int.max // 设置最大位数
        // 去除double后面的0
        if let formattedString = numberFormatter.string(from: NSNumber(value: yourDoubleValue)) {
            // 123.456
            print("test->1:\(formattedString)")
        }
        if let formattedString = numberFormatter.string(from: NSNumber(value: f2)) {
            // 168
            print("test->3:\(formattedString)")
        }
        
        print("test->2:\(str4)")
        //false
//        let isWord = "abc d".isEnglistWord
        //无论什么情况都会crash
//        fatalError("test")
//        mm_printLog(str)
    }
    
    func fontTest() {
        let familyNames = UIFont.familyNames
        mm_printLog(familyNames)
    }
    
    func testAnaly() {
        
        var testCacheArr: [[TestWordModel]] = []
        var testTmpArr: [TestWordModel] = []
//        var sIndex
        for i in 0...10 {
            
        }
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
        // 不可以，会直接连 test.txt也创建成文件夹
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appendPathComponent(string: "test/test.txt")
        MMFileManager.createDirectory(path: path)
        MMFileManager.fileExist(path: path)
        mm_printLog(result)
//        mm_printLog(modelArr)
        
    }
    
    
    /// 进入后台暂停
    func timerTest36() {
        var count = 0
        //锁屏、进后台会暂停
//        timerStr = MMDispatchTimer.createTimer(startTime: 1, infiniteInterval: 2, isRepeat: true, async: true) {
//            count += 1
//            mm_printLog("DpatchTimer->\(count)")
//        }
        
        //需要手动将timer放到 runloop中
//        timer = Timer(fire: Date(timeIntervalSince1970: Date().timeIntervalSince1970 + 2), interval: 2, repeats: true, block: { _ in
////            guard let self = self else { return }
//            count += 1
//            mm_printLog("start->\(count)")
//        })
        //进后台会暂停，回到前台会连续执行两次。
//        mm_printLog("timer->\(Date().timeIntervalSince1970), \(count)")
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
        //            self.timer?.fire()
        //        }
        
        var timerCount = 0
        // 返回一个新的 Timer 对象，并且把它安排在当前的运行循环中的默认模式下， 需要手动停止，进入后台也会调用
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            if timerCount >= 10 {
                timer.invalidate()
            }
            timerCount += 1;
            mm_printLog("timer->\(Date().timeIntervalSince1970), \(timerCount)")
        }
        
//        UserDefaults.standard.removeObject(forKey: "kMMFuncToolTimerKey")
//        MMFuncTool.timerCount = 0
//        // 进后台会暂停,(默认添加到 RunLoop.Mode.default)
//        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(handleTimer(sender:)), userInfo: nil, repeats: true)
        // 不调用此方法也能执行，会在2s后执行。 调用此方法会立即执行一次。
//        timer?.fire()
        mm_printLog("timer->end")
    }
    static var timerCount: Int = 0
    @objc func handleTimer(sender: Timer) {
        print("test->timer: \(sender),\(MMFuncTool.timerCount)")
//        if MMFuncTool.timerCount == 30 {
//            timer?.invalidate()
//        }
        Toast(text: "timer: \(MMFuncTool.timerCount)").show()
        UserDefaults.standard.set(MMFuncTool.timerCount, forKey: "kMMFuncToolTimerKey")
        MMFuncTool.timerCount += 1
    }
    
    func audioTest_37_2() {
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            mm_printLog("test->收到通知")
        }
        mm_printLog("点击->")
        DispatchQueue.global(qos: .background).asyncAfter(deadline: DispatchTime.now() + 1) {
            mm_printLog("后台->")
            self.player.play(urlStr: "https://ydlunacommon-cdn.nosdn.127.net/b2e09863e147dacef4d2dacf2188775b.mp3")

        }
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            mm_printLog("后台->")
//            self.player.play(urlStr: "https://ydlunacommon-cdn.nosdn.127.net/b2e09863e147dacef4d2dacf2188775b.mp3")
//
//        }
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
        
        let index = EnumTest2.index(20)
        if case EnumTest2.index(let val) = index {
            mm_printLog("test->取值方式1:\(val)")
        }
        if case let .index(val) = index {
            mm_printLog("test->取值方式2:\(val)")
        }
    }
}

struct TestWordModel: Codable {
    let word: String
    let title: String
    let trs: String
}

enum EnumTest: Int {
    case one = 0
    case two = 1
    
}

enum EnumTest2 {
    case type_1
    case index(Int)
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


