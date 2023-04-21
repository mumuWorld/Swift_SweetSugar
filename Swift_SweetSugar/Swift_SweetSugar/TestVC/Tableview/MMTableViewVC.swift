//
//  MMTableViewVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/4.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

protocol MMCellProtocol: UITableViewCell {
    func updateItem(item: MMCellItemProtocol)
}

protocol MMCellItemProtocol {
    var cellType: MMCellProtocol.Type { get }
    
    var data: Any? { get set }
    
    func clickHandle() -> Void
    
    func clickHandle(indexPath: IndexPath) -> Void

}

struct MMCellItem: MMCellItemProtocol {
    func clickHandle(indexPath: IndexPath) {
        
    }
    

    var _data: Any?
    
    var click: ((MMCellItemProtocol) -> Void)?
}

extension MMCellItem {
    var data: Any? {
        get { _data }
        set { _data = newValue }
    }
    
    var cellType: MMCellProtocol.Type {
        return MMSingleLabelTableCell.self
    }
    
    func clickHandle() {
        click?(self)
    }
}

extension MMSingleLabelTableCell: MMCellProtocol {
    func updateItem(item: MMCellItemProtocol) {
        guard let data = item.data as? String else { return }
        titleLabel.text = data
    }
}

class MMTableViewVC: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var dataArray: [MMCellItemProtocol]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.mm_registerNibCell(classType: MMSingleLabelTableCell.self)
        dataArray = [
            MMCellItem(_data: "局部刷新测试", click: { [unowned self] _ in
                let vc = MMListUpdateViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }),
            MMCellItem(_data: "动态高度测试", click: { [unowned self] _ in
                let vc = MMListAutoHeightViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }),
        ]
    }

}

extension MMTableViewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataArray[indexPath.row]
        guard let cell = tableview.mm_dequeueReusableCell(classType: item.cellType, indexPath: indexPath) as? MMCellProtocol else { return UITableViewCell() }
        cell.updateItem(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = dataArray[indexPath.row]
        item.clickHandle()
    }
}
