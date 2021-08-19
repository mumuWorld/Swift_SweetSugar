//
//  MMStackCollectionViewLayout.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/8/19.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMStackCollectionViewLayout: UICollectionViewFlowLayout {
    
    var maxItemSize: CGSize = .zero
    
    var minItemSize: CGSize = .zero
    
    var _attributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        _attributes.removeAll()
        let count = collectionView?.numberOfItems(inSection: 0) ?? 0
        let center_y = (collectionView?.mm_height ?? 0) * 0.5
        for i in 0...count {
            let  attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            let center_x = CGFloat(i) * 150 + itemSize.width
            attr.size = itemSize
            attr.center = CGPoint(x: center_x, y: center_y)
            _attributes.append(attr)
        }
            
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let _attributes = super.layoutAttributesForElements(in: rect)
//        guard var attributes = _attributes else { return _attributes }
        let size = collectionView?.mm_size ?? .zero
        let curOffset = collectionView?.contentOffset ?? .zero
        for attribute in _attributes {
            //距中心点距离
            let distance = abs(attribute.center.x - curOffset.x - size.width * 0.5)
            let scale = 1 - (distance / (size.width * 0.5)) * 0.5
            attribute.transform = CGAffineTransform(scaleX: scale, y:  scale)
//            attribute.
        }
        
        return _attributes
    }
    
    var offset: CGPoint = .zero
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        offset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return offset
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
}
