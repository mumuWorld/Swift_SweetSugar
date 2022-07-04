//
//  ScrollTableViewCell.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/4/21.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class ScrollTableViewCell: UITableViewCell {
    
    lazy var scrollView: UIScrollView = {
        let item = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        item.isPagingEnabled = true
        item.isScrollEnabled = true
        item.contentSize = CGSize(width: 900, height: 50)
        item.backgroundColor = .red
        item.bounces = false
        return item
    }()
    
    lazy var fir: UIView = {
        let item = UIView()
        item.backgroundColor = .brown
        return item
    }()

    lazy var sec: UIView = {
        let item = UIView()
        item.backgroundColor = .gray
        return item
    }()
    
    lazy var thir: UIView = {
        let item = UIView()
        item.backgroundColor = .green
        return item
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(scrollView)
        scrollView.addSubview(fir)
        scrollView.addSubview(sec)
        scrollView.addSubview(thir)
        fir.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        sec.frame = CGRect(x: 300, y: 0, width: 300, height: 50)
        thir.frame = CGRect(x: 600, y: 0, width: 300, height: 50)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
