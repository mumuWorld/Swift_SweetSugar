//
//  MMFuncTool+Sec.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/10/10.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation
import UIKit
//import MMHomeWork

//MARK: - Some Any

extension MMFuncTool {
    class MusicPlayer {
        var playlist: any Collection<String> = []

        func play(_ playlist: some Collection<String>) {
            self.playlist = playlist
        }
    }
    
    
    func testFramework() -> Void {
//        MMHomeWorkTool().start()
    }
}

extension MMFuncTool {
    
    func regularTest_22() {
        printDeviceInfo()
//        regularTest()
    }
    
    func printDeviceInfo() {
        let device = UIDevice.current

        // 获取设备名： iPhone， Synonym for model. Prior to iOS 16, user-assigned device name
        let deviceName = device.name

        // 获取系统名称 :  iOS
        let systemName = device.systemName

        // 获取系统版本 : 17.1
        let systemVersion = device.systemVersion

        // 获取设备型号 : iPhone
        let deviceModel = device.model
        // iPhone
        let localizedModel = device.localizedModel
        // iPhone11,2 （iPhoneX）
        let deviceString = getPhoneModel()
        
        print("设备名: \(deviceName)")
        print("系统名称: \(systemName)")
        print("系统版本: \(systemVersion)")
        print("设备型号: \(deviceModel)")
        print("localizedModel: \(localizedModel)")
        print("deviceString: \(deviceString)")

    }
    
    func getPhoneModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let deviceString = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return deviceString
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
}

typealias Filter = (CIImage) -> CIImage

extension MMFuncTool {
    func blur(radius: Double) -> Filter {
        return { image in
            let parameters = [
                kCIInputRadiusKey: radius,
                kCIInputImageKey: image
            ]
            guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else { fatalError() }
            guard let outputImage = filter.outputImage else { fatalError() }
            return outputImage
        }
    }
    
    /// “生成固定颜色的滤镜
    func colorGenerator(color: UIColor) -> Filter {
        return { _ in
            let c = CIColor(color: color)
            let parameters = [kCIInputColorKey: c]
            guard let filter = CIFilter(name: "CIConstantColorGenerator",
                                        parameters: parameters) else { fatalError() }
            guard let outputImage = filter.outputImage else { fatalError() }
            return outputImage
        }
    }
    
    /// 合成滤镜
    func compositeSourceOver(overlay: CIImage) -> Filter {
        return { image in
            let parameters = [
                kCIInputBackgroundImageKey: image,
                kCIInputImageKey: overlay
            ]
            guard let filter = CIFilter(name: "CISourceOverCompositing",
                                        parameters: parameters) else { fatalError() }
            guard let outputImage = filter.outputImage else { fatalError() }
            // 将输出图像裁剪为与输入图像一致的尺寸
            let cropRect = image.extent
            return outputImage.cropped(to: cropRect)
        }
    }
    
    func colorOverlay(color: UIColor) -> Filter {
        return { image in
            let overlay = self.colorGenerator(color: color)(image)
            return self.compositeSourceOver(overlay: overlay)(image)
        }
    }
}
