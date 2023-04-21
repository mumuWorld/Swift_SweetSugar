//
//  CollectionViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/4/9.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import SnapKit

class CollectionViewController: UIViewController {
    
    let itemW = ScreenWidth - 200
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: ScreenWidth + 40, height: 100)
        layout.itemSize = CGSize(width: itemW , height: 100)

        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect(x: 50, y: 100, width: itemW, height: 100), collectionViewLayout: layout)
//        let cv = UICollectionView(frame: CGRect(x: 0, y: 100, width: ScreenWidth + 40, height: 100), collectionViewLayout: layout)
        cv.bounces = false
        cv.isPagingEnabled = true
//        cv.isPagingEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.mm_registerNibCell(classType: SingleViewCell.self)
//        cv.contentInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20)
        return cv
    }()
    
    lazy var collectionView_2: UICollectionView = {
        let layout = MMStackCollectionViewLayout()
//        layout.itemSize = CGSize(width: ScreenWidth + 40, height: 100)
        layout.maxItemSize = CGSize(width: 200, height: 100)
        layout.itemSize = CGSize(width: 200, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect(x: -ScreenWidth, y: 250, width: ScreenWidth * 3, height: 100), collectionViewLayout: layout)
//        let cv = UICollectionView(frame: CGRect(x: 0, y: 100, width: ScreenWidth + 40, height: 100), collectionViewLayout: layout)
        
        cv.isPagingEnabled = true
//        cv.isPagingEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.mm_registerNibCell(classType: SingleViewCell.self)
//        cv.contentInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20)
        return cv
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let item = UICollectionViewFlowLayout()
        item.minimumLineSpacing = 12
        item.minimumInteritemSpacing = 1
        item.estimatedItemSize = CGSize(140, 30)
        item.itemSize = UICollectionViewFlowLayout.automaticSize
        item.scrollDirection = .horizontal
        return item
    }()
    
    lazy var collectionView_3: UICollectionView = {
        let item = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        item.showsHorizontalScrollIndicator = false
        item.showsVerticalScrollIndicator = false
        item.dataSource = self
        item.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        item.delegate = self
//        item.contentInsetAdjustmentBehavior = .never
        item.backgroundColor = .lightGray
        item.mm_registerNibCell(classType: MMSingleLabelCollectionViewCell.self)
        return item
    }()

    
    var curOffset: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(collectionView_2)
        
        view.addSubview(collectionView_3)
        collectionView_3.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(400)
            make.height.equalTo(40)
        }
//        flowLayout.itemSize = CGSize(150, 30)
//        collectionView_3.invalidateIntrinsicContentSize()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 3, delay: 0, options: [UIView.AnimationOptions.curveEaseOut]) {
//            self.collectionView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
            self.collectionView.contentOffset = CGPoint(x: ScreenWidth, y: 0)
        } completion: { (stat) in
            mm_printLog("动画完成")
        }

    }
}

//extension CollectionViewController: UICollectionViewDelegateFlowLayout {
//
//}
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView_3 {
            return 1
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView_3 {
            let cell = collectionView.mm_dequeueReusableCell(classType: MMSingleLabelCollectionViewCell.self, indexPath: indexPath)
            cell.textLabel.text = "水电费水电费水电费手动阀打撒"
            return cell
        }
        let cell = collectionView.mm_dequeueReusableCell(classType: SingleViewCell.self, indexPath: indexPath)
        cell.index = indexPath.row
        mm_printLog("加载了->\(indexPath.row)")
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        curOffset = scrollView.contentOffset
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) -> Void {
        mm_printLog("减速->")
//        scrollView.setContentOffset(scrollView.contentOffset, animated: false)
//        handleScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mm_printLog("停止拖动->\(decelerate)")
//        handleScroll(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mm_printLog("最终拖动")
//        handleScroll(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        mm_printLog("最终Animation")
    }
    
    func handleScroll(_ scrollView: UIScrollView) -> Void {
        if scrollView == collectionView_2 {
            return
        }
        let offset = abs(Int(scrollView.contentOffset.x) % Int(ScreenWidth))
        var index = Int(floor(scrollView.contentOffset.x / ScreenWidth))
        
        var isLeft = true
        if scrollView.contentOffset.x < curOffset.x { //向右滑
            isLeft = false
        }
        
        if CGFloat(offset) < ScreenWidth * 0.1 {
            scrollView.setContentOffset(CGPoint(x: index * Int(ScreenWidth), y: 0), animated: true)
        } else {
            if isLeft {
                index += 1
            }
            scrollView.setContentOffset(CGPoint(x:(index) * Int(ScreenWidth), y: 0), animated: true)
        }
    }
}
