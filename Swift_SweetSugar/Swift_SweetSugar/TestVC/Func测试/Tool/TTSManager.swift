////
////  TTSManager.swift
////  XiaoP
////
////  Created by Dong Liu on 2024/4/16.
////
//
//import AVFoundation
//import Foundation
//import StreamingKit
//import YDCommon
//
//typealias PlaySSEAudioFunction = (String) -> Void
//open class TTSManager:NSObject {
//    private let punctuationPattern = "[,，.。;；~：:！!？?]|——|……"
//    public static let NO_PLAY_ID = -1
//    private lazy var punctuationRegex: NSRegularExpression = try! NSRegularExpression(pattern: punctuationPattern, options: [])
//
//    public private(set) var playId: Int = NO_PLAY_ID
//    private var prePlayId:Int = NO_PLAY_ID
//    private var curPlayText = ""
//    private var previousPunctuationIndex = -1
//    @YDAtomic private var ttsPlayState: TTSPlayState = .Idle
//    @YDAtomic private var enableTTS = true
//    @YDAtomic private var sentenceWillPlay: [String] = []
//    @YDAtomic var ttsRequestBlocks:[(PlaySSEAudioFunction,String)] = []
//    private static let TTS_HTTP_REQUEST_TEXT_LENGTH_LIMIT = 450
//    @YDAtomic private var audioItemsWillBePlayed:[Int:[String]] = [:]
//    public weak var ttsPlayDelegate:TTSPlayDelegate?
//    
//    public func test() {
//        // Example usage:
////        let inputString = "Hello, world! How are you?；你好，世界。"
//        let inputString = "Markdown 是一种轻量级标记语言，它允许用户使用易读易写的纯文本格式编写文档，然后转换成HTML、PDF等多种格式。Markdown的语法简单且直观，主要包括以下几种格式：\n\n标题：使用\"#\"号表示，\"#\"号的数量表示标题的级别，最多支持6级标题。\n\n\"# 一级标题\"\n\"## 二级标题\"\n\"### 三级标题\"\n以此类推，直到\"###### 六级标题\"\n\n\n段落：使用空行分隔，每个段落之间需要有一个空行。\n列表：\n\n有序列表使用数字加点表示，如：\n\n\"1. 第一项\"\n\"2. 第二项\"\n\n\n无序列表使用减号或星号表示，如：\n\n\"- 项一\"\n\"* 项二\"\n\n\n\n\n强调：\n\n使用\"*\"包围文本表示斜体，如：\"斜体\"\n使用\"**\"包围文本表示加粗，如：\"粗体\"\n使用\"~~\"包围文本表示删除线，如：\"删除线\"\n\n\n链接：使用\"链接文本\"表示链接，如：\"百度\"\n图片：使用\"\"表示图片，如：\"\"\n代码块：使用三个反引号````包围代码块，可以指定代码块的语言，如：print(\"Hello, World!\")\n表格：使用竖线\"|\"和连字符\"-\"表示，如：| 标题1 | 标题2 | 标题3 |\n| ----- | ----- | ----- |\n| 单元格1 | 单元格2 | 单元格3 |\n引用：使用\">\"表示，可以嵌套引用，如：«这是一级引用««这是二级引用»»»\n分隔线：使用三个以上的星号\"\"、减号\"---\"或下划线\"___\"表示，如：*\n任务列表：使用\"- [ ]\"表示未完成的任务，使用\"- [x]\"表示完成的任务，如：\n\n\n[x] 完成作业\n[ ] 写报告\n以上是Markdown的一些基本格式，这些格式使得Markdown文本具有很高的可读性和易用性。\n\n"
//        
////        let matches = punctuationRegex.matches(in: inputString, options: [], range: NSRange(location: 0, length: inputString.utf16.count))
////
////        for index  in  0 ..< matches.count {
////            let matchedString = (inputString as NSString).substring(with: matches[index].range)
////            print(matchedString)
////        }
//        
//        let r = splitParagraphToSingleSentence(inputString)
//        for text in r {
//            debugPrint(text)
//        }
//        
//    }
//
//    public override init() {}
//
//    public func speak(id: Int, isEnd: Bool = true, text: String, forcePlay: Bool = true) -> Bool {
//        var segments: [String] = []
//        var segmentCount = 1
//        if text.count > TTSManager.TTS_HTTP_REQUEST_TEXT_LENGTH_LIMIT {
//             segmentCount = 2
//            while true {
//                if (text.count / segmentCount > TTSManager.TTS_HTTP_REQUEST_TEXT_LENGTH_LIMIT) {
//                    segmentCount += 1
//                } else {
//                    break
//                }
//            }
//            let segmentLength = text.count / segmentCount
//
//            var startIndex = text.startIndex
//            while startIndex < text.endIndex {
//                let endIndex = text.index(startIndex, offsetBy: segmentLength, limitedBy: text.endIndex) ?? text.endIndex
//                segments.append(String(text[startIndex..<endIndex]))
//                startIndex = endIndex
//            }
//        } else {
//            segments.append(text)
//        }
//        for segmentindex in 0 ..< segmentCount {
//            let singleSentences = splitParagraphToSingleSentence(segments[segmentindex])
//            let sentenceCount = singleSentences.count
//            if sentenceCount >= 1 {
//                for sentenceindex in 0 ..< sentenceCount {
//                    executeSpeak(id: id, isEnd: isEnd && segmentindex == (segmentCount - 1) && sentenceindex == (sentenceCount - 1), text: singleSentences[sentenceindex], forcePlay: forcePlay)
//                }
//            } else {
//                executeSpeak(id: id, isEnd: isEnd && segmentindex == (segmentCount - 1), text: segments[segmentindex], forcePlay: forcePlay)
//            }
//        }
//        return true
//    }
//    // 对text进行单句拆分
//    fileprivate func splitParagraphToSingleSentence(_ text: String) -> [String] {
//        var result = [String]()
//        var previousPunctuationIndex = 0
//        let matches = punctuationRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
//        for index in 0 ..< matches.count {
//            let match = matches[index]
//            if previousPunctuationIndex == 0 {
//                let range = NSRange(location: 0, length: match.range.location + 1) // 把标点符号也放上去
//                let matchedString = (text as NSString).substring(with: range)
//                result.append(matchedString)
//            } else {
//                let range = NSRange(location: previousPunctuationIndex + 1, length: match.range.location - previousPunctuationIndex)
//                let matchedString = (text as NSString).substring(with: range)
//                result.append(matchedString)
//            }
//            previousPunctuationIndex = match.range.location
//            //             处理这种形式的text:    ,Hello
//            if index == (matches.count - 1) {
//                let textEndRangeBound = text.utf16.count
//                if match.range.upperBound < textEndRangeBound {
//                    let endRange = NSRange(location: previousPunctuationIndex + 1, length: textEndRangeBound - previousPunctuationIndex - 1)
//                    let matchedString = (text as NSString).substring(with: endRange)
//                    result.append(matchedString)
//                }
//            }
//
//        }
//        return result
//    }
//    
//
//    // 每来一句话，直接拼接到string上，取出上一次标的符号的index，以及本次最后一个标点符号的index，然后取出这两个index之间的字符串，塞到队列中。上次的标点符号的index等于本次的最后一个标点符号的index。
//     private func executeSpeak(id: Int, isEnd: Bool, text: String, forcePlay: Bool = false) -> Bool
//    {
////        customTTSLog(content: "TTSManager speak: \(text),id:\(id)")
//        guard self.enableTTS || forcePlay else {
//            customTTSLog(content: "TTSManager已经关闭，不再接受数据")
//            return false
//        }
//        let text = text.replacingOccurrences(of: "\n", with: "")
//        if playId != id {
//            stopCurAudio()
//            playId = id
//            restartPlayTTS()
//        }
//        curPlayText += text
//
//        let matches = punctuationRegex.matches(in: curPlayText, options: [], range: NSRange(location: 0, length: curPlayText.utf16.count))
//        if isEnd {
//            ttsPlayState = .Text_Input_Finished
//            //            直接插入到代播放队列
//            if !text.isEmpty {
//                textPushQueue.sync { [weak self] in
//                    guard let self = self else { return }
//                    $sentenceWillPlay.mutate {
//                        $0.append(text)
//                    }
//                    ttsTextQueueSemaphore.signal()
//                }
//            } else {
//                ttsTextQueueSemaphore.signal()
//            }
//
//        } else if let last = matches.last {
//            if previousPunctuationIndex != -1 {
//                if previousPunctuationIndex != last.range.location {
//                    let range = NSRange(location: previousPunctuationIndex + 1, length: last.range.location - previousPunctuationIndex)
//                    let matchedString = (curPlayText as NSString).substring(with: range)
//
//                    textPushQueue.sync { [self] in
//                        $sentenceWillPlay.mutate {
//                            $0.append(matchedString)
//                        }
//                        ttsTextQueueSemaphore.signal()
//                    }
//                    previousPunctuationIndex = last.range.location
//                }
//            } else {
////                第一句话
//                let range = NSRange(location: 0, length: last.range.location + 1) // 把标点符号也放上去
//                previousPunctuationIndex = last.range.location
//                let matchedString = (curPlayText as NSString).substring(with: range)
//                textPushQueue.sync { [self] in
//                    $sentenceWillPlay.mutate {
//                        $0.append(matchedString)
//                    }
//                    ttsTextQueueSemaphore.signal()
//                }
//            }
//        } 
//        return true
//    }
//
//    private func restartPlayTTS() {
//        ttsPlayState = .Start
//        ttsTextQueueSemaphore = DispatchSemaphore(value: 0)
//        self.ttsSSEReqestQueueSemaphore = DispatchSemaphore(value: 0)
//        self.ttsSSEHttpRequestSemaphore = DispatchSemaphore(value: 0)
//        self.$audioItemsWillBePlayed.mutate {
//            $0[self.playId] = []
//        }
//        startTTSRequest()
//        startPlayAudio()
//    }
//
//    var laststartime: Date = .init()
//    var lastendtime: Date = .init()
//
//    var lastmsgStarttime: Date = .init()
//    var lastmsgEndtime: Date = .init()
//    private var ttsRequestToken: Cancelable?
//    var sseRequestIdMap: [String: Bool] = [:]//每次请求生成一个id作为key，value是true；当有新的请求时，需要把上次的id的对应的value改为false，保证后续的响应被丢弃掉。
//    private var currentTTSRequestMsgId = ""
//    // 如果当前播放的text，流式接口还未完全返回，那么，此刻不能直接请求新的流式接口，而是等待上一个流式接口返回后，再请求新的流式接口。
//    func playSSEAudio(content: String) {
//        guard self.isASKSSERunning() else {
//            return
//        }
//        self.ttsRequestToken?.cancel()
//        if !self.currentTTSRequestMsgId.isEmpty {
//            self.sseRequestIdMap[self.currentTTSRequestMsgId] = false
//        }
////        MARK: 这是流式的接口调用，暂时留着
////        let ttsRequest = TTSStream.Request()
//        let ttsRequest = TTSOneTime.Request()
//
//        ttsRequest.format = "mp3"
//        ttsRequest.text = content
//        let requestId = NSUUID().uuidString
//        self.sseRequestIdMap[requestId] = true
//        self.currentTTSRequestMsgId = requestId
//        self.laststartime = Date()
//        customTTSLog(content: "start tts request:\(content)")
//        self.ttsRequestToken = HttpClient.xiapHttpClient.send(ttsRequest, complete: {[weak self] success ,data  in
//            guard let self = self,self.sseRequestIdMap[self.currentTTSRequestMsgId] == true else {
//                return
//            }
////            customTTSLog(content: "status: \(response.status.rawValue)")
//            let responsetime = Date()
////            customTTSLog(content: "Begin Response time: \(responsetime.timeIntervalSince(self.laststartime))")
//            self.ttsSSEHttpRequestSemaphore.signal()
//            customTTSLog(content: "signal: playSSEAudio:\(content)")
//            self.lastendtime = Date()
//            customTTSLog(content: "End Response time: \(self.lastendtime.timeIntervalSince(self.laststartime))")
//            //            没有数据就等待，当这边塞入数据后，要进行通知。
//            if success,let voice = data.bufferData
//            {
//                let voiceCount = voice.count
//                print("voice count:\(voiceCount)")
//                let data = Data(voice)
//                let path = data.writeToTmpFile()
//                if let path {
//                    self.$audioItemsWillBePlayed.mutate {
//                        $0[self.playId]?.append(path)
//                    }
//                }
//                self.ttsPlayer.queue(path!)
//                customTTSLog(content: "mp3 queue:\(content)")
//
////                 MARK: TODO 测试代码，待删
//
//                let url = URL(string: path!)!
//                let asset = AVAsset(url: url)
//                let title = String(voiceCount)
//                let artist = "test"
//
////                group.enter()
////                var item: PlaylistItem?
//                let duration = asset.loadValuesAsynchronously(forKeys: ["duration"]) {
//                    var error: NSError?
//
//                    // If the duration loads, construct a "normal" item,
//                    // otherwise, construct an error item.
//                    switch asset.statusOfValue(forKey: "duration", error: &error) {
//                    case .loaded:
////                        self.bufferSeconds = self.bufferSeconds + asset.duration
////                        item = PlaylistItem(url: url, title: title, artist: artist, duration: asset.duration)
//                        customTTSLog(content: "duration:\(asset.duration.seconds)")
//
//                    case .failed where error != nil:
//                        customTTSLog(content: "loadValuesAsynchronously error")
////                        item = PlaylistItem(title: title, artist: artist, error: error!)
//
//                    default:
//                        let error = NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError)
////                        item = PlaylistItem(title: title, artist: artist, error: error)
//                    }
//                }
//            }
//           
//        })
//        
//        //        MARK: 这是流式的接口调用，暂时留着
////        self.ttsRequestToken = HttpClient.xiapHttpClient.sendSSE(ttsRequest) { [weak self] isComplete, response in
////            guard let self = self,self.sseRequestIdMap[self.currentTTSRequestMsgId] == true else {
////                return
////            }
////            customTTSLog(content: "status: \(response.status.rawValue)")
////            if response.status == TTSStream.Response.Status.begin {
////                let responsetime = Date()
////                self.lastmsgStarttime = Date()
////                customTTSLog(content: "Begin Response time: \(responsetime.timeIntervalSince(self.laststartime))")
////            } else if isComplete {
////                self.ttsSSEHttpRequestSemaphore.signal()
////                customTTSLog(content: "signal: playSSEAudio:\(content)")
////                let responsetime = Date()
////                self.lastmsgEndtime = Date()
////                customTTSLog(content: "End Response time: \(responsetime.timeIntervalSince(self.lastmsgStarttime))")
////            } else if response.status == .message {
////                //            每次消息到来都会回调一次
////
////                // MARK: TODO 搞个tts音频管理队列，当收到消息音频，转化为音频数据后，塞入队列；音频播放器从队列中取数据进行播放。
////
////                //            没有数据就等待，当这边塞入数据后，要进行通知。
////                let voiceCount = response.data?.data?.voice?.audio?.count ?? 0
////                print("voice count:\(voiceCount)")
////                if voiceCount > 0, let voiceFragment = response.data?.data?.voice,
////                   let voice = voiceFragment.audio, let status = voiceFragment.status,
////                   status == 1
////                {
////                    self.lastmsgEndtime = Date()
////                    customTTSLog(content: "period:\(self.lastmsgEndtime.timeIntervalSince(self.lastmsgStarttime))")
////                    self.lastmsgStarttime = Date()
////                    let data = Data(voice.hexToBytes())
////                    let path = data.writeToTmpFile()
////                    if let path {
////                        self.$audioItemsWillBePlayed.mutate {
////                            $0[self.playId]?.append(path)
////                        }
////                    }
////                    self.ttsPlayer.queue(path!)
////                    customTTSLog(content: "mp3 queue:\(content)")
////
//////                 MARK: TODO 测试代码，待删
////
////                    let url = URL(string: path!)!
////                    let asset = AVAsset(url: url)
////                    let title = String(voiceCount)
////                    let artist = "test"
////
//////                group.enter()
//////                var item: PlaylistItem?
////                    let duration = asset.loadValuesAsynchronously(forKeys: ["duration"]) {
////                        var error: NSError?
////
////                        // If the duration loads, construct a "normal" item,
////                        // otherwise, construct an error item.
////                        switch asset.statusOfValue(forKey: "duration", error: &error) {
////                        case .loaded:
//////                        self.bufferSeconds = self.bufferSeconds + asset.duration
//////                        item = PlaylistItem(url: url, title: title, artist: artist, duration: asset.duration)
////                            customTTSLog(content: "duration:\(asset.duration.seconds)")
////
////                        case .failed where error != nil:
////                            customTTSLog(content: "loadValuesAsynchronously error")
//////                        item = PlaylistItem(title: title, artist: artist, error: error!)
////
////                        default:
////                            let error = NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError)
//////                        item = PlaylistItem(title: title, artist: artist, error: error)
////                        }
////                    }
////                }
////            }
////        }
//    }
//
//    private var askSSEDispatchItem: DispatchWorkItem?
//    private var ttsTextQueueSemaphore = DispatchSemaphore(value: 0)
//    private var ttsSSEReqestQueueSemaphore = DispatchSemaphore(value: 0) //tts http request task queue semaphore
//    private var ttsSSEHttpRequestSemaphore = DispatchSemaphore(value: 0) //tts http request semaphore
//
//    private var textPushQueue: DispatchQueue = .init(label: "TTSManager::textPushQueue")
//    private var ttsRequestPushQueue: DispatchQueue = .init(label: "TTSManager::ttsRequestPushQueue")
//    func startPlayAudio() {
//        customTTSLog(content:"startPlayAudio" )
//        askSSEDispatchItem = DispatchWorkItem(block: { [weak self] in
//            guard let self = self else { return }
//            while self.isASKSSERunning() {
//                customTTSLog(content: "playState:\(self.ttsPlayState)")
//                if !self.sentenceWillPlay.isEmpty {
//                    let data = self.$sentenceWillPlay.mutate {
//                        if $0.isEmpty {
//                            return ""
//                        } else {
//                            return $0.removeFirst() as String
//                        }
//                    }
////                    let chatMsg = ChatMessage(noticeType: MessageSource.SERVER, clientMsg: nil, serverMsg: data)
////                    self.setChatMessage(data: chatMsg)
//                    if data.count > 0 {
////                        需要等待上一句话的流式消息完全返回。
//                        let block: (PlaySSEAudioFunction, String) = (self.playSSEAudio, data)
//                        self.ttsRequestPushQueue.sync {
//                            self.$ttsRequestBlocks.mutate {
//                                $0.append(block)
//                            }
//                            self.ttsSSEReqestQueueSemaphore.signal()
//                        }
//                    } else {
//                        customTTSLog(content: "获取的字符串是Empty")
//                    }
//
//                } else if self.ttsPlayState == .Text_Input_Finished { // 待播放的tts文字为空，不会有更多的文字输入
//                    customTTSLog(content: "tts request创建完了")
//                    self.ttsPlayState = .TTS_REQUEST_Finished
//                    break
//                }                
//                let result = self.ttsTextQueueSemaphore.wait(timeout: .now() + .milliseconds(500 * 1000))
//                switch result {
//                case .success:
//                    customTTSLog(content: "TTSManager::startPlayAudio:: called by text insert")
//                case .timedOut:
//                    customTTSLog(content: "TTSManager::startPlayAudio:: called by timeout")
//                    self.stopCurAudio()
//                default:
//                    customTTSLog(content: "")
//                }
//
//            }
//
//        })
//        if let item = self.askSSEDispatchItem {
//            DispatchQueue.global().async(execute: item)
//        }
//    }
////   @YDAtomic var enableTTSRequest = true
//    
//    func startTTSRequest()  {
//        let item = DispatchWorkItem { [weak self] in
//            guard let self = self else {
//                return
//            }
//            while self.isASKSSERunning() {
//                self.ttsSSEReqestQueueSemaphore.wait()
//                customTTSLog(content: "wait end for tts request.")
//                if !self.ttsRequestBlocks.isEmpty {
//                    let block = self.$ttsRequestBlocks.mutate {
//                        $0.removeFirst()
//                    }
//                    let (function, content) = block
//                    function(content)
//                    self.ttsSSEHttpRequestSemaphore.wait()
//                }  else if self.ttsPlayState == .TTS_REQUEST_Finished {
//                    self.ttsPlayState = .Idle
//                    customTTSLog(content: "所有的tts请求执行完毕，回归idle状态")
//                }
//            }
//            
//        }
//        DispatchQueue.global().async(execute: item)
//    }
//
//    open func stopCurAudio() {
//        customTTSLog(content:"stopCurAudio" )
//        self.ttsRequestToken?.cancel()
//        if !self.currentTTSRequestMsgId.isEmpty {
//            self.sseRequestIdMap[self.currentTTSRequestMsgId] = false
//        }
//        ttsPlayer.stop()
//        ttsPlayer.clearQueue()
//        previousPunctuationIndex = -1
//        $sentenceWillPlay.mutate {
//            $0.removeAll()
//        }
//        $ttsRequestBlocks.mutate {
//            $0.removeAll()
//        }
//        $audioItemsWillBePlayed.mutate {
//            $0.removeAll()
//        }
//        curPlayText = ""
//        if ttsPlayState != .Close {
//            ttsPlayState = .Idle
//        }
//        ttsTextQueueSemaphore.signal()
//        prePlayId = playId
//        playId = TTSManager.NO_PLAY_ID
//        askSSEDispatchItem?.cancel()
//        self.ttsSSEReqestQueueSemaphore.signal()
//        
//    }
//    
//    public func updateTTSPlayState(state:TTSPlayState) {
//        self.ttsPlayState = state
//    }
//
//    public func isASKSSERunning() -> Bool {
//        return ttsPlayState != .Idle && ttsPlayState != .Close
//    }
//
//    public func shutDown() {
//        enableTTS = false
//        self.ttsPlayState = .Close
//        self.stopCurAudio()
//    }
//    
//    public func open(){
//        enableTTS = true
//        self.ttsPlayState = .Idle
//    }
//
//    public lazy var ttsPlayer: STKAudioPlayer = {
////        audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
////        audioPlayer.meteringEnabled = YES;
////        audioPlayer.volume = 1;
////        STKaudioop
//        var optionsTmp = STKAudioPlayerOptions()
//        optionsTmp.flushQueueOnSeek = true
//        optionsTmp.enableVolumeMixer = false
//
//        optionsTmp.equalizerBandFrequencies = (Float32(50),
//                                               Float32(100),
//                                               Float32(200),
//                                               Float32(400),
//                                               Float32(800),
//                                               Float32(1600),
//                                               Float32(2600),
//                                               Float32(16000),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0),
//                                               Float32(0))
//        optionsTmp.readBufferSize = UInt32(0)
//        optionsTmp.bufferSizeInSeconds = Float32(0)
//        optionsTmp.secondsRequiredToStartPlaying = Float32(0)
//        optionsTmp.gracePeriodAfterSeekInSeconds = Float32(0)
//        optionsTmp.secondsRequiredToStartPlayingAfterBufferUnderun = Float32(0)
//
//        let stkplayer = STKAudioPlayer(options: optionsTmp)
//        stkplayer.meteringEnabled = true
//        stkplayer.volume = 0.1
//        stkplayer.delegate = self
//        return stkplayer
//
//    }()
//}
//
//extension TTSManager:STKAudioPlayerDelegate {
//    public func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
//        
//    }
//    
//    public func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
//        
//    }
//    
//    public func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
//        
//    }
//    
//    public func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
//        if stopReason == .userAction || stopReason == .error {
//            var stopedAudioId = TTSManager.NO_PLAY_ID
//            if stopReason == .error {
//                stopedAudioId = self.playId
//            } else if stopReason == .userAction {
//                //            1、点击播放另一个音频，停止播放当前音频，并播放新的； stopAudioId = prePlayId, playId != prePlayId, playId = newValue
//                //            2、直接调用了stopCurAudio，停止播放当前音频; stopAudioId = prePlayId,playId = NO_ID
//                stopedAudioId = self.prePlayId
//            }
//            customTTSLog(content: "用户手动停止或者播放出现错误，导致播放结束，playId:\(stopedAudioId)")
//            self.ttsPlayDelegate?.onPlayFinished(itemId: stopedAudioId, finishReason: stopReason)
//        } else if playId != TTSManager.NO_PLAY_ID, let audioItemPath = queueItemId as? String {
//            self.$audioItemsWillBePlayed.mutate {
//                $0[playId]?.remove(object: audioItemPath)
//            }
//            customTTSLog(content: "待播放items:\(self.audioItemsWillBePlayed[playId]?.count),ttsPlayState:\(self.ttsPlayState), playqueue isempty:\((self.audioItemsWillBePlayed[self.playId]?.isEmpty ?? true))")
//            if self.ttsPlayState == .TTS_REQUEST_Finished, self.audioItemsWillBePlayed[self.playId]?.isEmpty ?? true {
//                customTTSLog(content: "所有文本播放结束:\(curPlayText)")
//                self.ttsPlayDelegate?.onPlayFinished(itemId: self.playId, finishReason: stopReason)
//            }
//        }
//        customTTSLog(content: "didFinishPlayingQueueItemId: reasone\(stopReason.rawValue)")
//
//    }
//    
//    public func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
//        
//    }
//    
//    
//}
//
//public protocol TTSPlayDelegate:AnyObject {
//    func onPlayFinished(itemId:Int,finishReason:STKAudioPlayerStopReason)
//}
