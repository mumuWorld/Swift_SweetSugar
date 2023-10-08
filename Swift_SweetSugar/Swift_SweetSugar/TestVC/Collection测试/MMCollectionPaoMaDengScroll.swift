//
//  MMCollectionPaoMaDengScroll.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/9/5.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

class MMCollectionPaoMaDengScroll: UICollectionViewFlowLayout {
    
    var _attributes: [UICollectionViewLayoutAttributes] = []
    
    var minItemSize: CGSize = .zero
        
    var maxDistance: CGFloat = 0
    
    var collectionViewSize: CGSize = .zero
    
    var _itemDistance: CGFloat = 0
    
    var hasInit: Bool = false
    
    override func prepare() {
        super.prepare()
        guard !hasInit else { return }
        hasInit = true
        collectionViewSize = collectionView?.frame.size ?? .zero
//        minItemSize = CGSize(ceil(itemSize.width * 0.8), ceil(itemSize.height * 0.8))
        minItemSize = itemSize
//        _itemDistance = ceil((collectionViewSize.width - minItemSize.width) * 0.5)
        _itemDistance = itemSize.width
        
        let count = collectionView?.numberOfItems(inSection: 0) ?? 0
        let center_y = collectionViewSize.height * 0.5
        let middleWidth = minItemSize.width * 0.5
        // 超过这个最大距离就保持最大程度的形变
        maxDistance = collectionViewSize.width * 0.5
//        maxDistance = middleWidth + itemSize.width * 0.5
        _attributes.removeAll()
        for i in 0..<count {
            let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            let center_x = CGFloat(i) * _itemDistance + middleWidth
            attr.size = minItemSize
            attr.center = CGPoint(x: center_x, y: center_y)
            mm_printLog("test->frame: \(attr.frame)")
            _attributes.append(attr)
        }
    }
    
//    override var collectionViewContentSize: CGSize {
//        get {
//            let count = collectionView?.numberOfItems(inSection: 0) ?? 0
//            let size = CGSize(CGFloat(count) * _itemDistance + minItemSize.width, collectionViewSize.height)
//            return size
//        }
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let attrs = super.layoutAttributesForElements(in: rect) else { return nil }
//        let attrs = _attributes.filter({ $0.frame.minX > rect.minX && $0.frame.maxX < rect.maxX })
        
        
        let curOffset = collectionView?.contentOffset ?? .zero
        //加一个像素的临界值
        let mix_x = curOffset.x - _itemDistance + 1
        
//        let max_x = curOffset.x + collectionViewSize.width - (minItemSize.width - _itemDistance) - 1
        let max_x = curOffset.x + collectionViewSize.width - 1

        let middle_x = collectionViewSize.width * 0.5
        
        let attrs = _attributes.filter {
            if $0.frame.maxX >= rect.minX && $0.frame.minX <= rect.maxX {
                //距中心点距离
                let distance = $0.center.x - curOffset.x - middle_x
                let absDistance = abs(distance)
                //控制最远距离
                let holdDistance = min(absDistance, maxDistance)
                let ratio = holdDistance / maxDistance

                mm_printLog("test->hold: \(absDistance), \(maxDistance), ratio: \(ratio)")
//                attribute.zIndex = -Int(distance)
                
                let scale = 1 - (ratio * 0.1)
//                let scale = 1.0
               
                // 最多30° 是 0.523的弧度
//                let angle = scale * Double.pi * 0.25
                var angle = ratio * 0.523
                if distance < 0 {
                    angle *= -1
                }
                
                let alpha = 1 - ratio * 0.4
                $0.alpha = alpha
                print("test->angle: \(angle), scacle:\(scale), alpha=\(alpha)")
                var transform = CATransform3DIdentity
                transform.m34 = -1.0 / 1000
                transform = CATransform3DRotate(transform, angle, 0, 1, 0)
                transform = CATransform3DScale(transform, scale, scale, 0)
                $0.transform3D = transform
                return true
            }
            return false
        }
//        for (_, attribute) in attrs.enumerated() {
//            
//            //在屏幕右边、屏幕左边不进行计算
//            if attribute.frame.minX < rect.minX || attribute.frame.maxX > rect.maxX {
////                attribute.zIndex = -Int(mix_x) - i
////                attribute.transform = .identity
////                attribute.alpha = 0
////                attribute.transform3D = CATransform3DIdentity
////                mm_printLog("test-> 重置: \(attribute.frame.origin.x), \(mix_x), \(max_x)")
//            } else {
//                attribute.alpha = 1
//                //距中心点距离
//                let distance = attribute.center.x - curOffset.x - middle_x
//                let absDistance = abs(distance)
//                //控制最远距离
//                let holdDistance = min(absDistance, maxDistance)
//                let ratio = holdDistance / maxDistance
//
//                mm_printLog("test->hold: \(absDistance), \(maxDistance), ratio: \(ratio)")
////                attribute.zIndex = -Int(distance)
//                
//                let scale = 1 - (ratio * 0.1)
////                let scale = 1.0
//               
//                // 最多30° 是 0.523的弧度
////                let angle = scale * Double.pi * 0.25
//                var angle = ratio * 0.523
//                if distance < 0 {
//                    angle *= -1
//                }
//                
//                let alpha = 1 - ratio * 0.4
//                attribute.alpha = alpha
//                print("test->angle: \(angle), scacle:\(scale), alpha=\(alpha)")
//                var transform = CATransform3DIdentity
//                transform.m34 = -1.0 / 1000
//                transform = CATransform3DRotate(transform, angle, 0, 1, 0)
//                transform = CATransform3DScale(transform, scale, scale, 0)
//                attribute.transform3D = transform
//            }
//        }
        mm_printLog("test->\(attrs.count), rect:\(rect)")

        return attrs
        
        // 算出离中心点的距离， 记录0 为不旋转， 最大是0.349： 20°，
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
