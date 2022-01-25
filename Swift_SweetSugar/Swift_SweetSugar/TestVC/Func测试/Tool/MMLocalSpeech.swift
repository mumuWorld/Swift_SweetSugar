//
//  MMLocalSpeech.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/25.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import AVFAudio

class MMLocalSpeech: NSObject {
    
    static let shared: MMLocalSpeech = MMLocalSpeech()
    
    lazy var speech: AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        speech.delegate = self
    }
    
    var _completion: (() -> Void)?
    var _start: (() -> Void)?
    
    func speech(text: String, start: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        //先停止
        stop()
        _start = start
        _completion = completion
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            mm_printLog(error)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.4;
        speech.speak(utterance)
    }
 
    func stop() {
        guard speech.isSpeaking else { return }
        if !speech.stopSpeaking(at: .immediate) {
            speech.stopSpeaking(at: .word)
        }
    }
}

extension MMLocalSpeech: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        mm_printLog("text->播放开始")
        _start?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        mm_printLog("text->播放完成")
        _completion?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        mm_printLog("text->取消")
        _completion?()
    }
}
