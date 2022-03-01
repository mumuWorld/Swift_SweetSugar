//
//  HomeListVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class HomeListVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    lazy var listArr: [HomeListItem] = {
        let path = Bundle.main.path(forResource: "home_list", ofType: "plist")
        let data = try! Data.init(contentsOf: URL(fileURLWithPath: path!))
        let arrInfo = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        guard let arr = [HomeListItem].deserialize(from: arrInfo as? [Any]) as? [HomeListItem] else {
            return []
        }
        return arr
    }()
    
    var model: MMSimpleModel = MMSimpleModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.mm_registerNibCell(classType: HomeListItemCell.self)
        mm_printLog(MMFileManager.cachePath)
        model.name = "original"
        model.target = self
#if Test
        // get log
//        mm_printLog("get log")
        #endif
        
        NSSetUncaughtExceptionHandler { exception in
            let stack = exception.callStackReturnAddresses
            mm_printLog(stack)
            let sy = exception.callStackSymbols
            mm_printLog(sy)
            let data = try? JSONSerialization.data(withJSONObject: sy, options: .fragmentsAllowed)
            try? data?.write(to: URL(fileURLWithPath: "/Users/mumu/Downloads/image_download/crash.text"))
        }
        let sigs = [SIGHUP, SIGINT, SIGQUIT, SIGILL, SIGTRAP, SIGABRT,
                    SIGIOT, SIGEMT, SIGFPE, SIGKILL, SIGBUS, SIGSEGV, SIGSYS]
        for sig in sigs {
            signal(sig) { value in
                mm_printLog("crash->\(String(value))")
                mm_printLog("stack->\(Thread.callStackSymbols)")
                do {
                    let stack = Thread.callStackSymbols.joined(separator: "\n")
                    let data = stack.data(using: .utf8)
                    try data?.write(to: URL(fileURLWithPath: "/Users/mumu/Downloads/image_download/crash.text"))
                } catch let e {
                    mm_printLog(e)
                }
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        mm_printLog("")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        mm_printLog("")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        mm_printLog("")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        mm_printLog("")
    }
}

extension HomeListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.mm_dequeueReusableCell(classType: HomeListItemCell.self, indexPath: indexPath)
        cell.itemModel = listArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //播放发音
        let item = listArr[indexPath.row]
        let routerStr = NAME_SPACE + "." + item.routerVC
        let routerClass = NSClassFromString(routerStr) as! UIViewController.Type
        navigationController?.pushViewController(routerClass.init(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
}
