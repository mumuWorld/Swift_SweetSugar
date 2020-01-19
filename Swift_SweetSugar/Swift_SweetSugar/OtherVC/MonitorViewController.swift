//
//  MonitorViewController.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/11/21.
//  Copyright © 2019 Mumu. All rights reserved.
//

import UIKit


class MonitorViewController: UIViewController {
    
    var targetVC: MonitorViewController?
    
    var tag: Int = 0
    
    lazy var listView: UITableView = {
        let list = UITableView(frame: view.bounds)
        list.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        list.delegate = self
        list.dataSource = self
        return list
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(listView)
        targetVC = self
        
        if targetVC! > self {
            
        }
//        LXDAppFluecyMonitor().startMonitoring()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        mm_printLog(message: "释放->\(self)")
    }
}

extension MonitorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String("测试--- \(indexPath.row)")
            if (indexPath.row > 0 && indexPath.row % 30 == 0) {
        //        usleep(2000000);
                sleep(2);
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sleep(2)
    }
}

extension MonitorViewController: Comparable {
    static func < (lhs: MonitorViewController, rhs: MonitorViewController) -> Bool {
        return lhs.tag < rhs.tag
    }
    
    static func > (lhs: MonitorViewController, rhs: MonitorViewController) -> Bool {
        return lhs.tag > rhs.tag
    }
    
    
}
