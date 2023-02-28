//
//  CollectionContainerTableViewCell.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/4/21.
//  Copyright © 2022 Mumu. All rights reserved.
//

import UIKit

class CollectionContainerTableViewCell: UITableViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CollectionContainerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as! TestCollectionViewCell
        return cell
    }
}
