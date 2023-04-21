//
//  MMListAutoHeightViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/4/14.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

class MMListAutoHeightViewController: UIViewController {

    @IBOutlet weak var listView: UITableView!
    
    var adapt: MMTableViewAdapt!

    override func viewDidLoad() {
        super.viewDidLoad()

        listView.estimatedRowHeight = 40
        listView.rowHeight =  UITableView.automaticDimension
        listView.mm_registerClassCell(classType: MMAutoLabelTableViewCell.self)
        adapt = MMTableViewAdapt(listView: listView)
        
        
        var dataArray: [MMCellAutoItem] = [ ]
        for i in 0...10 {
            dataArray.append(MMCellAutoItem(data: false, click: { [unowned self] item, indexpath in
                mm_printLog("点击了第\(i)个cell")
                let _item = item as? MMCellAutoItem
                if let isShow = _item?.data as? Bool {
                    _item?.data = !isShow
                }
                self.listView.reloadRows(at: [indexpath], with: .automatic)
            }))
        }
        adapt.updateData(data: dataArray)
    }

}

class MMCellAutoItem: MMCellItemProtocol {
    
    init(data: Any?, click: @escaping ((MMCellItemProtocol, IndexPath) -> Void)) {
        self.data = data
        self.click = click
    }
    
    func clickHandle() {
    
    }
    
    
    var data: Any?
    
    
    var cellType: MMCellProtocol.Type {
        return MMAutoLabelTableViewCell.self
    }
    
    func clickHandle(indexPath: IndexPath) {
        click?(self, indexPath)
    }
    
    var click: ((MMCellItemProtocol, IndexPath) -> Void)?
}
