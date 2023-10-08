//
//  MMStackCollectionViewLayout.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/8/19.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMStackCollectionViewLayout: UICollectionViewFlowLayout {
    
    private var _attributes: [UICollectionViewLayoutAttributes] = []
    
    var minItemSize: CGSize = .zero
        
    var maxDistance: CGFloat = 0
    
    private var _collectionViewSize: CGSize = .zero
    
    /// 每个item占据的宽度
    var eachItemWidth: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        guard _attributes.isEmpty else { return }
        _collectionViewSize = collectionView?.frame.size ?? .zero
//        minItemSize = CGSize(ceil(itemSize.width * 0.8), ceil(itemSize.height * 0.8))
        
        let count = collectionView?.numberOfItems(inSection: 0) ?? 0
        let center_y = _collectionViewSize.height * 0.5
        let middleWidth = minItemSize.width * 0.5
        // 超过这个最大距离就保持最大程度的形变
        maxDistance = _collectionViewSize.width * 0.5
        // index 0 时居中偏移量
        let initOffset = _collectionViewSize.width * 0.5 - itemSize.width * 0.5
        print("test->准备布局 initOffset: \(initOffset)")
        _attributes.removeAll()
        for i in 0..<count {
            let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            let x = CGFloat(i) * eachItemWidth + initOffset
            attr.size = itemSize
            attr.frame = CGRect(origin: CGPoint(x: x, y: 0), size: itemSize)
            _attributes.append(attr)
//            print("test->x: \(x)")
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let curOffset = collectionView?.contentOffset ?? .zero


        let middle_x = _collectionViewSize.width * 0.5
        
        let attrs = _attributes.filter {
            guard $0.frame.maxX >= rect.minX && $0.frame.minX <= rect.maxX else { return false }
            // 距中心点距离
            let distance = $0.center.x - curOffset.x - middle_x
            let absDistance = abs(distance)
            // 控制最远距离
            let holdDistance = min(absDistance, maxDistance)
            // 比例
            let ratio = holdDistance / maxDistance
            
//            print("test->hold: \(absDistance), \(maxDistance), ratio: \(ratio)")
            // 形变
            let scale = 1 - (ratio * 0.08)
            //                let scale = 1.0
           
            // 透明度变化
            let alpha = 1 - ratio * 0.6
            $0.alpha = alpha
//            print("test->angle: \(angle), scacle:\(scale), alpha=\(alpha)")
            
            // y轴旋转角度: 最多30° 是 0.523的弧度
            var angle = ratio * 0.523
            if distance < 0 {
                angle.negate()
            }
            var transform = CATransform3DIdentity
            transform.m34 = -1.0 / 1000
            transform = CATransform3DRotate(transform, angle, 0, 1, 0)
            transform = CATransform3DScale(transform, scale, scale, 1.0)
            $0.transform3D = transform
            return true
        }
//        print("test->\(attrs.count), rect:\(rect), curOffset:\(curOffset)")
        return attrs
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}


class CustomLayout {
    /// 根据位置创建对应的Transform
    /// - Parameter position: 从左到右 -1, 0, 1[居中展示], 2, 3
//    func createTransform(position: Int) -> CATransform3D {
//        var transform = CATransform3DIdentity
//        if position == 1 {
//            return transform
//        }
//        transform.m34 = -1.0 / 1500
//        // 20° = 0.35, 30° = 0.52
//        var angle: CGFloat = 0
//        var scale: CGFloat = 1
//        var translate: CGFloat = 0
//        if position == -1 {
//            angle = -0.52
////            scale = 0.95
//            translate = -_eachItemWidth * 2
//        } else if position == 0 {
//            angle = -0.35
//            scale = 1
//            translate = -_eachItemWidth
//        } else if position == 2 {
//            angle = 0.35
//            scale = 1
//            translate = _eachItemWidth
//        } else if position == 3 {
//            angle = 0.52
//            scale = 0.95
//            translate = _eachItemWidth * 2
//        }
////        transform = CATransform3DScale(transform, scale, scale, 1)
//        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
//        transform = CATransform3DTranslate(transform, translate, 0, 0)
//        return transform
//    }
    
//    /// 初始化滚动视图
//    func initRotateView() {
//        let x = (width - _itemSize.width) * 0.5
//        curIndex = 0
//        for index in 0...3 {
//            // 初始位置均为居中: 方便计算Transform
//            let cell = YDBootADRotateCollectionViewCell(frame: CGRect(origin: CGPoint(x: x, y: 0), size: _itemSize))
//            rotateViews.append(cell)
//            print("test->index: \(index), cell:\(cell)")
//            scrollContentView.addSubview(cell)
//            // cell的index
//            let offsetIndex = curIndex + index - 1
//            let data = updateIndexData(index: offsetIndex)
//            print("test->data: \(data)")
//            cell.transform3D = createTransform(position: index)
//            // 更新数据
//            cell.indexLabel.text = "index: \(data)"
//        }
//        // 将当前展示cell 蒙层隐藏, 播放视频
//        playShowCell()
//    }
//    
//    func scrollToNext() {
//        //停止播放上一个
//        let cell = rotateViews[1]
//        cell.testLabel.isHidden = true
//        curIndex += 1
////        print("test->当前index: \(curIndex)")
//        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseOut]) {
//            cell.topMaskView.alpha = 1
//            // 队列里的视图向左移动一个位置
//            for (index, element) in self.rotateViews.enumerated() {
//                element.transform3D = self.createTransform(position: index - 1)
//            }
//            self.rotateViews[2].topMaskView.alpha = 0
//        } completion: { _ in
//            // 将0移动到3，出队再入队
//            self.rotateViews[0].transform3D = self.createTransform(position: 3)
//            let element = self.rotateViews.removeFirst()
//            self.rotateViews.append(element)
//            // 播放
//            self.playShowCell()
//            // 更新将要展示cell的数据
//            let offsetIndex = self.curIndex + 2
//            let data = self.updateIndexData(index: offsetIndex)
//            element.indexLabel.text = "index:\(data)"
////            print("test->data: \(data)")
//        }
//    }
}
