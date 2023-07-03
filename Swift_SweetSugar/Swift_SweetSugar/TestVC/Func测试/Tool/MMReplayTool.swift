//
//  MMReplayTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/6/19.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation
import ReplayKit



class MMReplayTool: NSObject {
    
    static var shared: MMReplayTool = MMReplayTool()
    
    var isRecord: Bool = false
    
    func startRecordingButtonTapped() {
        let recorder = RPScreenRecorder.shared()
        recorder.delegate = self
        if recorder.isAvailable {
            recorder.startRecording { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Recording started.")
                }
            }
        } else {
            print("Recording is not available.")
        }
    }
    
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        recorder.startRecording { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Recording started.")
            }
        }
        isRecord = true
    }
    
    func stopRecording() {
        isRecord = false
        let recorder = RPScreenRecorder.shared()
        recorder.stopRecording { (previewViewController, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Recording stopped.")
                previewViewController?.previewControllerDelegate = self
                UIViewController.currentViewController()?.present(previewViewController!, animated: true, completion: nil)
            }
        }
    }
}

extension MMReplayTool: RPPreviewViewControllerDelegate, RPScreenRecorderDelegate {
    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print("Recording availability changed.")
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Recording stopped.")
            previewViewController?.previewControllerDelegate = self
            UIViewController.currentViewController()?.present(previewViewController!, animated: true, completion: nil)

        }
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        UIViewController.currentViewController()?.dismiss(animated: true, completion: nil)
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        UIViewController.currentViewController()?.dismiss(animated: true, completion: nil)
        if activityTypes.contains(UIActivity.ActivityType.saveToCameraRoll.rawValue) {
            let recorder = RPScreenRecorder.shared()
            recorder.stopRecording { (previewViewController, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Recording stopped.")
                    previewViewController?.previewControllerDelegate = self
                    UIViewController.currentViewController()?.present(previewViewController!, animated: true, completion: nil)
                }
            }
        }
    }
    
//    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
//        if let error = error {
//            print(error.localizedDescription)
//        } else {
//            print("Recording stopped.")
//            previewViewController?.previewControllerDelegate = self
//            UIViewController.currentViewController()?.present(previewViewController!, animated: true, completion: nil)
//            let videoURL = previewViewController?.previewItem
//            // 获取视频文件的本地路径
//            if let videoURL = videoURL as? URL {
//                let fileManager = FileManager.default
//                let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                let videoPath = documentsPath.appendingPathComponent("recorded_video.mp4")
//                do {
//                    try fileManager.copyItem(at: videoURL, to: videoPath)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//
//    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
//        dismiss(animated: true, completion: nil)
//        if activityTypes.contains(UIActivity.ActivityType.saveToCameraRoll.rawValue) {
//            let recorder = RPScreenRecorder.shared()
//            recorder.stopRecording { (previewViewController, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else {
//                    print("Recording stopped.")
//                    previewViewController?.previewControllerDelegate = self
//                    UIViewController.currentViewController()?.present(previewViewController!, animated: true, completion: nil)
//                    if let previewItemURL = previewViewController?.previewItemURL {
//                        let fileManager = FileManager.default
//                        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                        let videoPath = documentsPath.appendingPathComponent("recorded_video.mp4")
//                        do {
//                            try fileManager.moveItem(at: previewItemURL, to: videoPath)
//                        } catch {
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//            }
//        }
//    }

}
