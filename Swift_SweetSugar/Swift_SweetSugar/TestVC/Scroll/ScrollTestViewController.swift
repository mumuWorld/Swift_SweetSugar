//
//  ScrollTestViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/4/21.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class ScrollTestViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let item = UIScrollView(frame: CGRect(x: 10, y: 200, width: 300, height: 300))
        item.isPagingEnabled = true
        item.isScrollEnabled = true
        item.contentSize = CGSize(width: 900, height: 300)
        item.backgroundColor = .lightGray
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
    
    lazy var tableV: UITableView = {
        let item = UITableView(frame: .zero, style: .plain)
        item.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        item.register(CollectionContainerTableViewCell.self, forCellReuseIdentifier: "CollectionContainerTableViewCell")
        item.register(ScrollTableViewCell.self, forCellReuseIdentifier: "ScrollTableViewCell")
        item.delegate = self
        item.dataSource = self
        return item
    }()

    lazy var headerView: UIView = {
        let item = UIView()
        return item
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(fir)
        scrollView.addSubview(sec)
        scrollView.addSubview(thir)
        sec.addSubview(tableV)
        fir.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        sec.frame = CGRect(x: 300, y: 0, width: 300, height: 200)
        thir.frame = CGRect(x: 600, y: 0, width: 300, height: 200)

        tableV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headerView.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        addScrollView(v: headerView)
        tableV.tableHeaderView = headerView
        addScrollView(v: fir)
        addCollection()
    }

}

extension ScrollTestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionContainerTableViewCell", for: indexPath) as! CollectionContainerTableViewCell

            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScrollTableViewCell", for: indexPath) as! ScrollTableViewCell
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as! LabelTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        addScrollView(v: v)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}

extension ScrollTestViewController {
    func addScrollView(v: UIView) {
        let _scrollView: UIScrollView = {
            let item = UIScrollView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
            item.isPagingEnabled = true
            item.isScrollEnabled = true
            item.contentSize = CGSize(width: 900, height: 100)
            item.backgroundColor = .red
            item.bounces = false
            return item
        }()
        
        var _fir: UIView = {
            let item = UIView()
            item.backgroundColor = .brown
            return item
        }()

        var _sec: UIView = {
            let item = UIView()
            item.backgroundColor = .gray
            return item
        }()
        
        var _thir: UIView = {
            let item = UIView()
            item.backgroundColor = .green
            return item
        }()
        
        v.addSubview(_scrollView)
        _scrollView.addSubview(_fir)
        _scrollView.addSubview(_sec)
        _scrollView.addSubview(_thir)
        _fir.frame = CGRect(x: 0, y: 0, width: 300, height: 80)
        _sec.frame = CGRect(x: 300, y: 0, width: 300, height: 80)
        _thir.frame = CGRect(x: 600, y: 0, width: 300, height: 80)
    }
    
    func addCollection() {
         let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: 50, height: 200)
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 16
            let item = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
            item.backgroundColor = .cyan
            item.delegate = self
            item.dataSource = self
    //        item.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            item.register(UINib(nibName: "TestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TestCollectionViewCell")
            item.showsHorizontalScrollIndicator = false
            item.bounces = false
            return item
        }()
        thir.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ScrollTestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as! TestCollectionViewCell
        return cell
    }
}

 
