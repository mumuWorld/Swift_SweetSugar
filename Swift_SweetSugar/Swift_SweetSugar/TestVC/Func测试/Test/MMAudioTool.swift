//
//  MMAudioTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/3/2.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class MMAudioTool {
    
    
    var _url: String = ""
    
    var playerItem: AVPlayerItem?
    
    lazy var player: AVPlayer = {
        let item = AVPlayer(playerItem: nil)
        return item
    }()
    
    
    func play(urlStr: String) {
        guard let url = URL(string: urlStr) else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            mm_printLog(error)
        }
        
        // 设置MPNowPlayingInfoCenter中显示的歌曲信息
        let nowPlayingInfo = [MPMediaItemPropertyTitle : "My Song 32"]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        mm_printLog("开始播放->1")

        player.play()
        mm_printLog("开始播放->2")
        /*
         iOS的AVPlayer在后台时调用play()无法正常播放是因为iOS系统限制了应用程序在后台运行时的音频播放能力。如果您想要实现在后台播放音频，可以使用以下两种方法：

         1. 使用Background Modes功能：将应用程序注册为支持“Audio”或“Remote notifications”背景模式之一，并且需要开启“Background fetch”选项。这样就可以让应用程序在后台继续播放音频。

         2. 使用远程控制：当用户锁屏或按下Home键进入其他应用程序时，您可以通过远程控制来控制AVPlayer的播放状态。例如，在锁屏界面上显示歌曲信息和控制按钮等。
         */
        setupRemoteTransportControls()
    }
    
    func setupRemoteTransportControls() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            self.player.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            self.player.pause()
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = false
        
        commandCenter.previousTrackCommand.isEnabled = false
        
    }
    
    deinit {
        mm_printLog("移除")
    }
    
//    override func remoteControlReceivedWithEvent(event: UIEvent) {
//        if event.type == UIEventType.RemoteControl{
//            switch event.subtype{
//                case .RemoteControlTogglePlayPause:
//                self.pauseAndPlayAction(self.playBtn);
//                break;
//                case .RemoteControlPreviousTrack:
//                self.preBtnAction(self.preBtn);
//                break;
//                case .RemoteControlNextTrack:
//                self.nextBtnAction(self.nextBtn);
//                break;
//                case .RemoteControlPlay:
//                self.pauseAndPlayAction(self.playBtn);
//                break;
//                case .RemoteControlPause:
//                self.pauseAndPlayAction(self.playBtn);
//                break;
//                default:
//                break;
//
//            }
//
//        }
//
//    }
    
}
