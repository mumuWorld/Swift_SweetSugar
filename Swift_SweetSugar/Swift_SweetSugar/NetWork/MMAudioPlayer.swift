//
//  MMAudioPlayer.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/2/6.
//  Copyright © 2025 Mumu. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayerManager() // 单例模式，确保 `audioPlayer` 不被释放
    var audioPlayer: AVAudioPlayer?

    var lastData: Data?
    
    func playAudio(data: Data) {
        do {
            if let type = detectAudioFormat(data: data) {
                print("📢 音频文件格式: \(type)")
            }
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self // 设置代理监听播放完成
            audioPlayer?.prepareToPlay()
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
                print("✅ AVAudioSession 设置成功")
            } catch {
                print("❌ AVAudioSession 配置失败: \(error.localizedDescription)")
            }
            
            audioPlayer?.play()
            print("🎵 音频播放中...")
        } catch {
            print("🎵❌ 播放失败: \(error.localizedDescription)")
        }
    }
    
    ///  AVAudioPlayer 仅支持 MP3, AAC, WAV, M4A，不支持 FLAC, OGG 等格式。
    @discardableResult
    func detectAudioFormat(data: Data) -> String? {
        let headerBytes = data.prefix(4) // 读取前 4 个字节
        let hexString = headerBytes.map { String(format: "%02X", $0) }.joined()
        
        print("📢 文件头: \(hexString)")

        switch hexString {
        case "494433": return "MP3 (ID3 Tag)"
        case "FFF1", "FFF9": return "AAC (ADTS)"
        case "4F676753": return "OGG"
        case "52494646": return "WAV 或 AVI (需进一步检查)"
        case "664C6143": return "FLAC"
        case "000001BA", "000001B3": return "MPEG 视频"
        default: return "未知格式"
        }
    }


    // 监听播放完成
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("✅ 音频播放完成")
        } else {
            print("⚠️ 播放未正常结束")
        }
    }
    
    func fetchAndPlay() {
        if let lastData {
            print("🎵 播放缓存...")
            playAudio(data: lastData)
            return
        }
        
        Task {
            do {
                let url = "https://dict.youdao.com/pronounce/base?client=iphonepro&imei=eb13da6da08b512ecd072e7654d21e15&phonetic=&appleGuest=0&abtest=2&dev_name=iPhone&idfa=66CE6B74-EBA9-4CD1-BDE7-34561E0D227C&appVersion=10.1.24&le=en&caid=43d55393556257b11d3ddcb4a2ad51d5&yduuid=eb13da6da08b512ecd072e7654d21e15&add_param_s_g_1=6B21B019-C002-4CAB-9EA4-F6C289C42B5D&vendor=AppStore&type=2&mysticTime=1738822820533&pointParam=add_param_s_g_0,add_param_s_g_1,mysticTime&mid=18.3&network=wifi&deviceName=iPhone&keyfrom=mdict.10.1.24.iphonepro&model=iPhone11,2&add_param_s_g_0=2D527D16-B3F4-42AE-9A1C-199F84F8D83B&word=February&screen=375x812&keyid=voiceDictAppIos&sign=00729F67E6DCD407C5DCD865B35AAA24&product=mdict"
                let result = try await MMNetWorkManager.shared.fetchData(from: url)
                lastData = result
                print("✅ 获取数据成功: \(result)")
                playAudio(data: result)
            } catch {
                print("❌ 请求失败: \(error.localizedDescription)")
            }
             
        }
    }
}
