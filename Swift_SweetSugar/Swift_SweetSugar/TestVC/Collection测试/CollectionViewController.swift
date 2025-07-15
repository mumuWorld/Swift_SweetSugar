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
        let cv = UICollectionView(frame: CGRect(x: 50, y: 100, width: itemW, height: 100), collectionViewLayout: ScrollLayout)
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
//        layout.maxItemSize = CGSize(width: 200, height: 100)
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
    
    lazy var ScrollLayout: MMCollectionPaoMaDengScroll = {
        let item = MMCollectionPaoMaDengScroll()
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
//        item.isPagingEnabled = true
        item.mm_registerNibCell(classType: MMSingleLabelCollectionViewCell.self)
        return item
    }()

    lazy var collectionView_4: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let item = UICollectionView(frame: .zero, collectionViewLayout: layout)
        item.showsHorizontalScrollIndicator = false
        item.showsVerticalScrollIndicator = false
        item.dataSource = self
        item.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        item.delegate = self
//        item.contentInsetAdjustmentBehavior = .never
        item.backgroundColor = .lightGray
        item.isPagingEnabled = true
        item.mm_registerNibCell(classType: MMSingleLabelCollectionViewCell.self)
        return item
    }()
    
    var curOffset: CGPoint = .zero
    
    var kBottmonHeight: CGFloat = 0
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    
    var cell0: MMRotateView!
    var cell1: MMRotateView!
    var cell2: MMRotateView!
    var cell3: MMRotateView!
    var cell4: MMRotateView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addFirstCollectionView()
//        view.addSubview(collectionView_2)
        bgImageView.isHidden = true
//        addCollection3()
//        addCustomScroll()
        addFourCollectionView()
    }
    
    var _eachItemWidth: CGFloat = 0

    func addFourCollectionView() {
        view.addSubview(collectionView_4)
        collectionView_4.snp.makeConstraints { (make) in
            make.top.equalTo(300)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func addFirstCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }
        
//        ScrollLayout.eachItemWidth = itemW
        ScrollLayout.itemSize = CGSizeMake(itemW, 200)
    }
    func addCustomScroll() {
        bgImageView.isHidden = true
        kBottmonHeight = kBottomSafeHeight;
        var botLogoH = kScreenWidth / 375 * 104
        var itemWidth = 418.0
        if kBottmonHeight > 0 {
            botLogoH += kBottmonHeight
            
        } else {
            
        }
        // 根据剩余高度，计算最大高度，然后根据比例 计算宽度，看是否能展示
        //TODO: 杨杰- 后面再算吧
        if kScreenWidth < 375 {
            itemWidth = 178
        } else if kBottmonHeight > 0 {
            itemWidth = 214
        }
        
        //16:9
        let itemHeight = ceil(itemWidth * 16 / 9)
        let itemSize = CGSizeMake(itemWidth, itemHeight)
        let x = (view.mm_width - itemSize.width) * 0.5
        _eachItemWidth = itemSize.width + 20
        
        cell0 = MMRotateView(frame: CGRect(origin: CGPoint(x: x, y: 100), size: itemSize))
        cell1 = MMRotateView(frame: CGRect(origin: CGPoint(x: x, y: 100), size: itemSize))
        cell2 = MMRotateView(frame: CGRect(origin: CGPoint(x: x, y: 100), size: itemSize))
        cell3 = MMRotateView(frame: CGRect(origin: CGPoint(x: x, y: 100), size: itemSize))
//        cell4 = MMRotateView(frame: CGRect(origin: .zero, size: itemSize))

        view.addSubview(cell0)
        view.addSubview(cell1)
        view.addSubview(cell2)
        view.addSubview(cell3)

        cell0.transform3D = createTransform(style: 0, itemW: 0)
        cell1.transform3D = createTransform(style: 1, itemW: 0)
        cell2.transform3D = createTransform(style: 2, itemW: 0)
        cell3.transform3D = createTransform(style: 3, itemW: 0)
//        cell4.transform3D = createTransform(style: 3)

//        let testView = UIView(frame: CGRect(x: 10, y: 100, width: 200, height: 300))
//        testView.backgroundColor = .cyan
//        testView.layer.transform =  CATransform3DIdentity
//        view.addSubview(testView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//
//                    UIView.animate(withDuration: 3) {
////                        self.cell1.center = CGPoint(x: middleX - itemW, y: centerY)
////                        self.cell2.center = CGPoint(x: middleX, y: centerY)
////                        self.cell3.center = CGPoint(x: middleX + itemW, y: centerY)
////                        self.cell0.center = CGPoint(x: middleX - itemW * 2, y: centerY)
//                        
////                        self.cell0.layer.transform = self.createTransform(style:-1, itemW: itemWidth)
////                        self.cell1.layer.transform = self.createTransform(style: 0, itemW: itemWidth)
////                        self.cell2.layer.transform = self.createTransform(style: 1, itemW: itemWidth)
////                        self.cell3.layer.transform = self.createTransform(style: 2, itemW: itemWidth)
////                        
//                        self.cell0.transform3D = self.createTransform(style:-1, itemW: itemWidth)
//                        self.cell1.transform3D = self.createTransform(style: 0, itemW: itemWidth)
//                        self.cell2.transform3D = self.createTransform(style: 1, itemW: itemWidth)
//                        self.cell3.transform3D = self.createTransform(style: 2, itemW: itemWidth)
//            //            self.cell4.transform3D = self.createTransform(style: 3)
//            
//                    } completion: { _ in
//                        // 将0 移到最后
////                        self.cell0.center = CGPoint(x: middleX + itemW * 2, y: centerY)
//                        self.cell0.transform3D = self.createTransform(style: 3, itemW: itemWidth)
//
//                    }
        }

    }
    
    func createTransform(style: Int, itemW: CGFloat) -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = -1.0 / 1200
        if style == 1 {
//            transform = CATransform3DRotate(transform, 0.4, 0, 1, 0)
            return transform
        }
        
        var angle: CGFloat = 0
        var scale: CGFloat = 0
        var translate: CGFloat = 0
        if style == 0 {
            angle = -0.3
            scale = 0.9
            translate = -_eachItemWidth
        } else if style == -1 {
            angle = -0.5
            scale = 0.8
            translate = -_eachItemWidth * 2
        } else if style == 2 {
            angle = 0.3
            scale = 0.9
            translate = _eachItemWidth
        } else if style == 3 {
            angle = 0.5
            scale = 0.8
            translate = _eachItemWidth * 2
        }
//        transform = CATransform3DScale(transform, scale, scale, 1)
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        transform = CATransform3DTranslate(transform, translate, 0, 0)
        return transform
    }
    
    func addCollection3() {
//        kBottmonHeight = kBottomSafeHeight;
//        var botLogoH = kScreenWidth / 375 * 104
//        var itemWidth = 418.0
//        if kBottmonHeight > 0 {
//            botLogoH += kBottmonHeight
//            
//        } else {
//            
//        }
//        // 根据剩余高度，计算最大高度，然后根据比例 计算宽度，看是否能展示
//        //TODO: 杨杰- 后面再算吧
//        if kScreenWidth < 375 {
//            itemWidth = 178
//        } else if kBottmonHeight > 0 {
//            itemWidth = 214
//        }
//        
//        //16:9
//        let itemHeight = ceil(itemWidth * 16 / 9)
//        ScrollLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//        
//        bgImageView.frame = view.bounds
//        view.addSubview(collectionView_3)
        view.insertSubview(collectionView_3, belowSubview: bgImageView)
        collectionView_3.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(100)
        }
        
//        self.collectionView.alpha = 0
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        UIView.animate(withDuration: 3, delay: 0, options: [UIView.AnimationOptions.curveEaseOut]) {
////            self.collectionView.setContentOffset(CGPoint(x: ScreenWidth, y: 0), animated: true)
//            self.collectionView.contentOffset = CGPoint(x: ScreenWidth, y: 0)
//        } completion: { (stat) in
//            mm_printLog("动画完成")
//        }
//        showCollection()
        
        collectionView_4.scrollToItem(at: IndexPath(row: 10, section: 0), at: .bottom, animated: false)
    }
    
    func showCollection() {
        
        UIView.animate(withDuration: 0.5) {
            self.bgImageView.mm_size = self.ScrollLayout.itemSize
            self.bgImageView.center = CGPoint(x: kScreenWidth * 0.5, y: 100 + self.ScrollLayout.itemSize.height * 0.5)
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.collectionView.alpha = 1
            } completion: { _ in
                self.bgImageView.alpha = 0
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView_3 {
            return 10
        }
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView_3 || collectionView == collectionView_4 {
            let cell = collectionView.mm_dequeueReusableCell(classType: MMSingleLabelCollectionViewCell.self, indexPath: indexPath)
            cell.textLabel.text = "水电费:\(indexPath.row)"
            cell.contentView.backgroundColor = UIColor.mm_randomColor()
            print("test-> 加载 cell: \(indexPath.row)")
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
