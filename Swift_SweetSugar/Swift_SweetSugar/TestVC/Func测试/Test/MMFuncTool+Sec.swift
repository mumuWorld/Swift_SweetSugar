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
import EventKit

var testEventCalendaIsRun: Bool = false

let signTitle: String = "每日签到活动"

extension MMFuncTool {
    func testEventCalendar_60() {
        if testEventCalendaIsRun == false {
            requestCalendarAccess { eventStore in
                if let store = eventStore {
                    self.checkIfCheckInReminderExists(in: store) { exists in
                        if exists {
                            print("⚠️ 已存在签到提醒，跳过添加")
                        } else {
                            self.addDailyCheckInReminder(with: store)
                        }
                    }
                    testEventCalendaIsRun = true
                } else {
                    // 可以提示用户去设置里授权
                    mm_printLog("test-> ❌ 日历权限未授权")
                }
            }
        } else {
            deleteCheckInReminders()
            testEventCalendaIsRun = false
        }
    }
    
    func checkIfCheckInReminderExists(in store: EKEventStore, completion: @escaping (Bool) -> Void) {
        let calendar = Calendar.current
        let startDate = Date()
        let endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!

        // 创建查询谓词（一个月范围内）
        let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let events = store.events(matching: predicate)

        // 判断是否存在至少一个匹配的签到事件
        let exists = events.contains {
            $0.title == signTitle
        }
        
        completion(exists)
    }
    
    func requestCalendarAccess(completion: @escaping (EKEventStore?) -> Void) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    completion(eventStore)
                } else {
                    print("❌ 日历权限未授权")
                    completion(nil)
                }
            }
        }
    }
    
    func addDailyCheckInReminder(with eventStore: EKEventStore) {
        let event = EKEvent(eventStore: eventStore)
        
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 9
        components.minute = 0
        
        guard let startDate = calendar.date(from: components) else { return }
        let endDate = startDate.addingTimeInterval(10 * 60 * 60) // 10小时后（19:00）

        event.title = signTitle
        event.notes = "去签到领取VIP奖励吧~"
        event.startDate = startDate
        event.endDate = endDate
        event.url = URL(string: "")
        event.calendar = eventStore.defaultCalendarForNewEvents

        // 提醒：事件开始时
        let alarm = EKAlarm(relativeOffset: 0)
        event.alarms = [alarm]

        // 每天重复
        let recurrenceRule = EKRecurrenceRule(
            recurrenceWith: .daily,
            interval: 1,
            end: nil
        )
        event.recurrenceRules = [recurrenceRule]

        do {
            try eventStore.save(event, span: .futureEvents)
            print("✅ 签到提醒已添加到系统日历")
        } catch {
            print("❌ 添加日历事件失败: \(error.localizedDescription)")
        }
    }
    
    func deleteCheckInReminders() {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            guard granted else {
                print("❌ 无法访问日历")
                return
            }
            
            // 查找时间范围：从 1 年前到未来 1 年
            let calendar = Calendar.current
            let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date())!
            let oneYearLater = calendar.date(byAdding: .year, value: 1, to: Date())!
            
            // 创建搜索谓词
            let predicate = eventStore.predicateForEvents(withStart: oneYearAgo, end: oneYearLater, calendars: nil)
            
            // 搜索匹配标题的事件
            let events = eventStore.events(matching: predicate).filter {
                $0.title == signTitle
            }
            
            if events.isEmpty {
                print("⚠️ 未找到可删除的签到提醒")
                return
            }
            
            // 删除找到的事件
            for event in events {
                do {
                    try eventStore.remove(event, span: .futureEvents, commit: false)
                } catch {
                    print("❌ 删除事件失败: \(error.localizedDescription)")
                }
            }
            
            do {
                try eventStore.commit()
                print("✅ 已删除签到提醒（共 \(events.count) 个）")
            } catch {
                print("❌ 提交删除失败: \(error.localizedDescription)")
            }
        }
    }
}

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
