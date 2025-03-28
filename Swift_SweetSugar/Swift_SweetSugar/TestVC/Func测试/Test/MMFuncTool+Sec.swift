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
    
    /// 分享测试
    func shareTest() {
        guard let vc = UIViewController.currentViewController() else { return }
        let text = "分享内容"
        let image = UIImage(named: "yww_1")
        let url = URL(string: "https://www.baidu.com")

        let activityViewController = UIActivityViewController(activityItems: [text, image!, url!], applicationActivities: nil)

//         在 iPad 上需要设置 `popoverPresentationController`
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = vc.view
            popoverController.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        // 在 UIViewController 里 present
        vc.present(activityViewController, animated: true, completion: nil)
    }
}

extension MMFuncTool {
    
    func sortTest() {
//        mysticTime=1742976042100;add_param_s_g_1=72566294-7CD9-458B-8256-A33966977BD7;add_param_s_g_0=4B6B36C3-F22A-4F6F-8BF4-F895C4DEFBCD;
        //
        let param: [String: String] = ["mysticTime": "1742976042100", "add_param_s_g_1": "72566294-7CD9-458B-8256-A33966977BD7", "add_param_s_g_0": "4B6B36C3-F22A-4F6F-8BF4-F895C4DEFBCD"]
        
        let result = param.compactMap { pair in
            return "\(pair.key)=\(pair.value)"
        }.sorted { (val1, val2) -> Bool in
            return val1.compare(val2, options: .caseInsensitive) == .orderedAscending
        }
        mm_printLog("test->result = \(result)")
    }
    
    func regularTest_22() {
//        printDeviceInfo()
        equalTest()
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
    
    func equalTest() {
        // struct_1 == struct_2    true
        // === 不合法， 必须是对象
        var struct_1 = MMSimpleStruct()
        let struct_2 = MMSimpleStruct()
        // struct_1 == struct_3 不合法，类型不一致
        let struct_3 = MMSimpleStruct2()
//         结构体的 == 挨个比较元素的值。 跟是否可变无关
//        struct_1.name = "aaa"
//        struct_2.name = "bbb"

        let str3_1 = MMSimpleStruct3(name: "123")
        let str3_2 = MMSimpleStruct3(name: "123")
        
//        let reuslt = str3_1 != str3_2
        
        // class_1 === class_2        false
        // == 不能直接比较。需要实现  Equatable 协议
        let class_1 = MMSimpleClass()
        let class_2 = MMSimpleClass()
        
        // ocClass_1 === ocClass_2         false
        // ocClass_1 == ocClass_2        false: oc对象的== 实际上比较的是哈希值， 因为NSObject实际上实现了 Equatable 协议
        let ocClass_1 = MMSimpleOCClass()
        let ocClass_2 = MMSimpleOCClass()
        // ocClass_3 == ocClass_1 true
        let ocClass_3 = ocClass_1

        let hashValue_1 = ocClass_1.hashValue
        let hashValue_2 = ocClass_2.hashValue
        
        // array1 == array2     true
        let array1 = [1, 2]
        let array2 = [1, 2]
        
        // == 因为元素不能用 == 比较， 所以不合法
        let array3 = [class_1]
        let array4 = [class_1]

        // dict1 == dict2 true
        let dict1 = ["1": 1]
        let dict2 = ["1": 1]

        // == 因为元素不能用 == 比较， 所以不合法
        let dict3 = ["1": class_1]
        let dict4 = ["1": class_1]
        
        mm_printLog("test-> \(class_1 === class_2)")
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
