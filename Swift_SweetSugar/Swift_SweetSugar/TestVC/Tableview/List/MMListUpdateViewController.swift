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
        listView.estimatedRowHeight = 40
        listView.rowHeight =  UITableView.automaticDimension
        listView.mm_registerNibCell(classType: MMSingleLabelTableCell.self)
        adapt = MMTableViewAdapt(listView: listView)
    }
    
    @IBAction func add(_ sender: UIButton) {
        adapt.add(data: MMCellItem(_data: "这是插入", click: { [unowned self] _ in
            mm_printLog("点击了->\(self)")
        }), index: adapt.dataArray.count - 2, animation: animation)
    }
    
    @IBAction func insertBottom(_ sender: UIButton) {
        adapt.add(data: MMCellItem(_data: "这是插入底部", click: { [unowned self] _ in
            mm_printLog("点击了->\(self)")
        }), index: adapt.dataArray.count, animation: animation)
        
        adapt.add(data: MMCellItem(_data: "这是插入底部2", click: { [unowned self] _ in
            mm_printLog("点击了->\(self)")
        }), index: adapt.dataArray.count, animation: animation)
    }
    
    @IBAction func remove(_ sender: Any) {
        adapt.remove(index: adapt.dataArray.count - 3)
    }
    // right = 1, left = 2
    var animation: UITableView.RowAnimation = .fade
    @IBAction func changeAnimation(_ sender: UIButton) {
        if animation == .middle {
            animation = .automatic
        } else if animation == .automatic {
            animation = .fade
        } else {
            animation = UITableView.RowAnimation(rawValue: animation.rawValue + 1) ?? .fade
        }
        sender.setTitle("切换动画: \(animation.rawValue)", for: .normal)
    }

}
