//
//  MMTableViewAdapt.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/12/22.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMTableViewAdapt: NSObject {
    
    let listView: UITableView

    var dataArray: [MMCellItemProtocol]!

    internal init(listView: UITableView) {
        self.listView = listView
        super.init()
        listView.delegate = self
        listView.dataSource = self
        
        dataArray = []
//        dataArray = [
//            MMCellItem(_data: "这是标题", click: { [unowned self] in
//            })
//        ]
//        for i in 0...10 {
//            dataArray.append(MMCellItem(_data: "这是标题_\(i)", click: { [unowned self] in
//            }))
//        }
    }
    
    func updateData(data: [MMCellItemProtocol]) {
        dataArray = data
        listView.reloadData()
    }
    
    func add(data:MMCellItemProtocol, index: Int, animation: UITableView.RowAnimation = .fade, toBottom: Bool = true) -> Void {
        dataArray.insert(data, at: index)
        listView.insertRows(at: [IndexPath(row: index, section: 0)], with: animation)
        
        listView.scrollToRow(at: IndexPath(row: dataArray.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    func remove(index: Int) -> Void {
        dataArray.remove(at: index)
        listView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .top)
    }
}

extension MMTableViewAdapt: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataArray[indexPath.row]
        guard let cell = tableView.mm_dequeueReusableCell(classType: item.cellType, indexPath: indexPath) as? MMCellProtocol else { return UITableViewCell() }
        cell.updateItem(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataArray[indexPath.row].clickHandle(indexPath: indexPath)
    }
}
