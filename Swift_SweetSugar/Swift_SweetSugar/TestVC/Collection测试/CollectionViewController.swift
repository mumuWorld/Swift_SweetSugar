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
        layout.itemSize = CGSize(width: ScreenWidth, height: 100)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: CGRect(x: -ScreenWidth, y: 100, width: ScreenWidth * 3, height: 100), collectionViewLayout: layout)
//        let cv = UICollectionView(frame: CGRect(x: 0, y: 100, width: ScreenWidth, height: 100), collectionViewLayout: layout)

        cv.isPagingEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.mm_registerNibCell(classType: SingleViewCell.self)
        return cv
    }()
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mm_printLog("停止拖动")
        let offset = Int(scrollView.contentOffset.x) % Int(ScreenWidth)
        let index = Int(scrollView.contentOffset.x / ScreenWidth)
        if CGFloat(offset) < ScreenWidth * 0.5 {
            scrollView.setContentOffset(CGPoint(x: index * Int(ScreenWidth), y: 0), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x:(index + 1) * Int(ScreenWidth), y: 0), animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        mm_printLog("最终拖动")
        let offset = Int(scrollView.contentOffset.x) % Int(ScreenWidth)
        let index = Int(scrollView.contentOffset.x / ScreenWidth)
        if CGFloat(offset) < ScreenWidth * 0.5 {
            scrollView.setContentOffset(CGPoint(x: index * Int(ScreenWidth), y: 0), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x:(index + 1) * Int(ScreenWidth), y: 0), animated: true)
        }
    }
}
