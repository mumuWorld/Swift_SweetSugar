//
//  AppDelegate.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/4/1.
//  Copyright © 2019年 Mumu. All rights reserved.
//

import UIKit
import BackgroundTasks
import OSLog
import DoraemonKit
import KSCrash
import Toaster

//import FlipperKit

private var previousExceptionHandler: (@convention(c) (NSException) -> Void)?

func setupUncaughtExceptionHandler() {
    // 获取之前的异常处理程序
    previousExceptionHandler = NSGetUncaughtExceptionHandler()

    // 设置自定义异常处理程序
    NSSetUncaughtExceptionHandler { exception in
        handleUncaughtException(exception)

        // 调用之前的异常处理程序（如果存在）
       previousExceptionHandler?(exception)
    }
}

func handleUncaughtException(_ exception: NSException) {
    print("Uncaught exception detected: \(exception.name)")
    print("Reason: \(exception.reason ?? "Unknown reason")")
    print("Call stack: \(exception.callStackSymbols)")

    // 可以在此处将日志写入文件或上传到远程服务
    UserDefaults.standard.set(exception.callStackSymbols, forKey: "kMMCrashCallStack")
    UserDefaults.standard.set("\(Date())", forKey: "kMMCrashCallStackDate")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SDKLogManager.shared.addLog(info: "test->启动: \(String(describing: launchOptions))")
        setupKSCrash()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MMTabBarViewController()
        window?.makeKeyAndVisible()
//        mm_printLog("mumu")
//        
//        let client = FlipperClient.shared()
//            let layoutDescriptorMapper = SKDescriptorMapper(defaults: ())
//            FlipperKitLayoutComponentKitSupport.setUpWith(layoutDescriptorMapper)
//            client?.add(FlipperKitLayoutPlugin(rootNode: application, with: layoutDescriptorMapper!))
//            client?.start()
        
//        do {
//            let socket = try NWListener.init(using: .udp, on: 1000)
//            print("test->error:\(socket)")
//        } catch {
//            print("test->error:\(error)")
//        }
        DoraemonStatisticsUtil.shareInstance().noUpLoad = true
        DoraemonManager.shareInstance().install()
        return true
    }
    
    func setupKSCrash() {
        
        let config = KSCrashConfiguration()
        config.monitors = [.all]
        
//        let installation = CrashInstallationStandard.shared
//        if let url = URL(string: "") {
//            installation.url = url
//        }
//

//        
//        installation.addConditionalAlert(
//            withTitle: "Crash Detected Common",
//            message: "The app crashed last time it was launched. Send a crash report?",
//            yesAnswer: "Sure!",
//            noAnswer: "No thanks"
//        )
        // 控制台打印
        let console = CrashInstallationConsole.shared
        console.printAppleFormat = true
        
//        let emailInstallation = CrashInstallationEmail.shared
//        emailInstallation.recipients = ["617958070@qq.com"]
//        emailInstallation.setReportStyle(.apple, useDefaultFilenameFormat: true)
        
//        emailInstallation.addConditionalAlert(
//                    withTitle: "Crash Detected Email",
//                    message: "The app crashed last time it was launched. Send a crash report?",
//                    yesAnswer: "Sure!",
//                    noAnswer: "No thanks"
//                )
        var installation: CrashInstallation?
        do {
//            try installation.install(with: config)
//            try emailInstallation.install(with: config)
            try console.install(with: config)
            installation = console
        } catch {
            mm_printLog("test->error:\(error)")
        }
        installation?.sendAllReports { reports, error in
            mm_printLog("test->completed,error:\(error), reports:\(reports)")
            reports?.forEach { item in
                if let _dict = item as? CrashReportDictionary {
                    let v = _dict.value
                    mm_printLog(_dict)
                    let data = try? JSONSerialization.data(withJSONObject: v, options: .fragmentsAllowed)
                    try? data?.write(to: URL(fileURLWithPath: "/Users/mumu/Downloads/image_download/crash.text"))
                } else if let strReport = item as? CrashReportString {
                    let data = strReport.value.data(using: .utf8)
                    try? data?.write(to: URL(fileURLWithPath: "/Users/mumu/Downloads/image_download/crash.text"))
                }
            }
        }
    }
    
    var tool: MMFuncTool = MMFuncTool()
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SDKLogManager.shared.addLog(info: "test->willFinishLaun: \(String(describing: launchOptions))")
        if MMMainManager.shared.isPrintLifeLog {
            mm_printLog(launchOptions ?? [:])
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        SDKLogManager.shared.addLog(info: "test->open: \(String(describing: options))")
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        mm_printLog("mumu: \(application.backgroundTimeRemaining)")

//        player.play(urlStr: "https://ydlunacommon-cdn.nosdn.127.net/b2e09863e147dacef4d2dacf2188775b.mp3")
        //开始后台任务
//       startBackgroundTaks()
//        startBackgroundTaks_2()
    }
    func startBackgroundTaks_2() {
        // block 只是回调结束，并不是在block内完成任务
        backgroundUpdateTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: { [weak self] in
            mm_printLog("test->关闭后台任务")
            UserDefaults.standard.set("\(Date())", forKey: "kMMBackgroundValue2")
            UserDefaults.standard.set(UIApplication.shared.backgroundTimeRemaining, forKey: "kMMBackgroundTimeRemaining")
            self?.finishBackgroundTaks()
//            self?.startBackgroundTaks_2()

        })
//        self.tool.timerTest36()
        UserDefaults.standard.set("\(Date())", forKey: "kMMBackgroundValue1")
      
        Toast(text: "start 后台任务").show()
        mm_printLog("test->开启后台任务:\(String(describing: backgroundUpdateTaskID))")
    }
    
    func startBackgroundTaks() {
        backgroundUpdateTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
        
        }
    }
    
    func finishBackgroundTaks() {
        guard let backgroundUpdateTaskID = self.backgroundUpdateTaskID else { return }
        Toast(text: "关闭后台任务").show()
        // 结束后台任务
        UIApplication.shared.endBackgroundTask(backgroundUpdateTaskID)
        self.backgroundUpdateTaskID = .invalid
        self.tool.timer?.invalidate()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.endReceivingRemoteControlEvents()
        UserDefaults.standard.set("\(Date())", forKey: "kMMBackgroundValue3")
//        finishBackgroundTaks()
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
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        mm_printLog("mumu")
        if userActivity.activityType.hasPrefix("com.AppCoda.SiriSortcuts.sayHi") {
            let alert = UIAlertController(title: "Siri Shortcut", message: "Siri Shortcut for saying 'Hi' was used.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIViewController.currentViewController()?.present(alert, animated: true)
            return true
        }
        return false
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

@available(iOS 14.0, *)
let logger = Logger(subsystem: "com.mumu", category: "test_new")

func mm_printLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
#if DEBUG
    // 1.获取文件名,包含后缀名
    let name = (file as NSString).lastPathComponent
    // 1.1 切割文件名和后缀名
    let fileArray = name.components(separatedBy: ".")
    // 1.2 获取文件名
    let fileName = fileArray[0]
    // 2.打印内容
    let printStr = "test->🔨[\(fileName) \(funcName)](\(lineNum)): \(message)"
    if #available(iOS 14.0, *) {
        debugPrint(printStr)
//        let str = "This is a debug message.:\(type(of: printStr))"
//        logger.debug(str)
//        logger.debug(printStr)
    } else {
        debugPrint("🔨[\(fileName) \(funcName)](\(lineNum)): \(message)")
    }
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
