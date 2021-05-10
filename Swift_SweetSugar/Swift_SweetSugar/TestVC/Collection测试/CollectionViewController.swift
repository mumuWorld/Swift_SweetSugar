//
//  CollectionViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/4/9.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: ScreenWidth + 40, height: 100)
        layout.itemSize = CGSize(width: ScreenWidth, height: 100)

        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect(x: -ScreenWidth, y: 100, width: ScreenWidth * 3, height: 100), collectionViewLayout: layout)
//        let cv = UICollectionView(frame: CGRect(x: 0, y: 100, width: ScreenWidth + 40, height: 100), collectionViewLayout: layout)
        
//        cv.isPagingEnabled = true
        cv.isPagingEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.mm_registerNibCell(classType: SingleViewCell.self)
//        cv.contentInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 20)
        return cv
    }()
    
    var curOffset: CGPoint = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
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

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        handleScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mm_printLog("停止拖动->\(decelerate)")
        handleScroll(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mm_printLog("最终拖动")
        handleScroll(scrollView)
    }
    
    func handleScroll(_ scrollView: UIScrollView) -> Void {
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
