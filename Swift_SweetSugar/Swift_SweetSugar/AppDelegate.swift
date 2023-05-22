//
//  AppDelegate.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/4/1.
//  Copyright © 2019年 Mumu. All rights reserved.
//

import UIKit
import BackgroundTasks
//import FlipperKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let home = HomeListVC()
        let navi = MMBaseNavigationController(rootViewController: home)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
//        mm_printLog("mumu")
//        
//        let client = FlipperClient.shared()
//            let layoutDescriptorMapper = SKDescriptorMapper(defaults: ())
//            FlipperKitLayoutComponentKitSupport.setUpWith(layoutDescriptorMapper)
//            client?.add(FlipperKitLayoutPlugin(rootNode: application, with: layoutDescriptorMapper!))
//            client?.start()
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        mm_printLog(launchOptions ?? [:])
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        mm_printLog("mumu")
        
        // 必须主线程
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        
    }

    var backgroundUpdateTaskID: UIBackgroundTaskIdentifier?
    
    var player: MMAudioTool = MMAudioTool()
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        mm_printLog("mumu: \(application.backgroundTimeRemaining)")
//        backgroundUpdateTaskID = application.beginBackgroundTask(expirationHandler: { [weak self] in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
//                guard let self = self, let taskID = self.backgroundUpdateTaskID else { return }
//                application.endBackgroundTask(taskID)
//                self.backgroundUpdateTaskID = .invalid
//            }
//        })
//        player.play(urlStr: "https://ydlunacommon-cdn.nosdn.127.net/b2e09863e147dacef4d2dacf2188775b.mp3")
//        backgroundUpdateTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
//                            mm_printLog("测试1")
//            guard let self = self else { return }
//            mm_printLog("测试2")
//            DispatchQueue.global(qos: .background).async {
//                mm_printLog("测试3")
//                // 延长后台任务的时间
//                while true {
//                    mm_printLog("测试4")
//                    if UIApplication.shared.backgroundTimeRemaining <= 30 {
//                        break
//                    }
//                    Thread.sleep(forTimeInterval: 1.0)
//                }
//                mm_printLog("测试5")
//                guard let backgroundUpdateTaskID = self.backgroundUpdateTaskID else { return }
//                mm_printLog("测试6")
//                // 结束后台任务
//                UIApplication.shared.endBackgroundTask(backgroundUpdateTaskID)
//            }
//        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.endReceivingRemoteControlEvents()
        guard let backgroundUpdateTaskID = self.backgroundUpdateTaskID else { return }
        // 结束后台任务
        UIApplication.shared.endBackgroundTask(backgroundUpdateTaskID)
        mm_printLog("mumu->回到前台结束任务")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        mm_printLog("mumu")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        mm_printLog("mumu")
    }

    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        mm_printLog("mumu")
        return true
    }
    
    func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        mm_printLog("mumu")
    }

//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        guard window != nil else {
//            mm_printLog("applicaiton->2")
//            return .portrait
//        }
//        if let vc = UIViewController.currentViewController() {
//            mm_printLog("applicaiton->1—\(vc.supportedInterfaceOrientations)")
//            return vc.supportedInterfaceOrientations
//        } else {
//            mm_printLog("applicaiton->2")
//            return .portrait
//        }
//    }
//    
    /// 禁用第三方键盘
    /// - Parameters:
    ///   - application:
    ///   - extensionPointIdentifier:
    /// - Returns:
//    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        //UIApplicationExtensionPointIdentifier(_rawValue: com.apple.keyboard-service
//        mm_printLog("\(extensionPointIdentifier)")
//        return true
//    }
}

func mm_printLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
#if DEBUG
    // 1.获取文件名,包含后缀名
    let name = (file as NSString).lastPathComponent
    // 1.1 切割文件名和后缀名
    let fileArray = name.components(separatedBy: ".")
    // 1.2 获取文件名
    let fileName = fileArray[0]
    // 2.打印内容
    debugPrint("🔨[\(fileName) \(funcName)](\(lineNum)): \(message)")
#endif
}

func mm_printLog<T, Target>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line, target: inout Target) where Target : TextOutputStream {
    
#if DEBUG
    // 1.获取文件名,包含后缀名
    let name = (file as NSString).lastPathComponent
    // 1.1 切割文件名和后缀名
    let fileArray = name.components(separatedBy: ".")
    // 1.2 获取文件名
    let fileName = fileArray[0]
    // 2.打印内容
    debugPrint("🔨[\(fileName) \(funcName)](\(lineNum)): \(message)", separator: "☆", to: &target)
#endif
}

func mm_printsLog(_ messages : Any..., file : String = #file, funcName : String = #function, lineNum : Int = #line) {
#if DEBUG
    // 1.获取文件名,包含后缀名
    let name = (file as NSString).lastPathComponent
    // 1.1 切割文件名和后缀名
    let fileArray = name.components(separatedBy: ".")
    // 1.2 获取文件名
    let fileName = fileArray[0]
    // 2.打印内容
    debugPrint("🔨[\(fileName) \(funcName)](\(lineNum)): \(messages)")
#endif
}
