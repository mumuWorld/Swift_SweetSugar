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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.mm_registerNibCell(classType: HomeListItemCell.self)
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