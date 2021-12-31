//
//  MMListUpdateViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/12/22.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMListUpdateViewController: UIViewController {
    
    @IBOutlet weak var listView: UITableView!
    
    var adapt: MMTableViewAdapt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.mm_registerNibCell(classType: MMSingleLabelTableCell.self)
        adapt = MMTableViewAdapt(listView: listView)
    }
    
    @IBAction func add(_ sender: UIButton) {
        adapt.add(data: MMCellItem(_data: "这是插入", click: { [unowned self] in
            mm_printLog("点击了->\(self)")
        }), index: adapt.dataArray.count - 2)
    }
    
    @IBAction func remove(_ sender: Any) {
            adapt.remove(index: adapt.dataArray.count - 3)
    }
}
