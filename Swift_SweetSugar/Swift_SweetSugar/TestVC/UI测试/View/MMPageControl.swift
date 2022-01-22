//
//  MMPageControl.swift
//  TianQi
//
//  Created by Mumu on 2022/1/15.
//

import UIKit

//class MMPageControl: UIView {
//
//    lazy var configure: MMPageControlConfigure = MMPageControlConfigure()
//
//    lazy var cacheSubviews: [UIView] = []
//
//    var fitWidth: CGFloat = 0
//
//    var curIndex: Int = 0
//
//
//    func updateConfigure(pConfigure: MMPageControlConfigure, curIndex: Int = 0) -> Void {
//        configure = pConfigure
//        removeSubviews()
//        for _ in 0..<configure.count {
//            createPageItem()
//        }
//        var curX: CGFloat = 0
//        subviews.enumerated().forEach { (index, item) in
//            if index == curIndex {
//                item.backgroundColor = configure.selectedColor
//                item.size = CGSize(width: configure.itemSelectedW, height: configure.itemH)
//            }
//            item.x = curX
//            curX = item.frame.maxX + configure.itemSpacing
//        }
//        self.curIndex = curIndex
//        //宽度就是减去最后一个空隙
//        fitWidth = curX - configure.itemSpacing
//    }
//
//    func createPageItem() -> Void {
//        let item = UIView()
//        item.backgroundColor = configure.color
//        item.size = CGSize(width: configure.itemW, height: configure.itemH)
//        item.layer.cornerRadius = configure.itemCornerRaidus
//        addSubview(item)
//    }
//}
//
//extension MMPageControl {
//
//    func setIndex(_ index: Int) -> Void {
//        if curIndex == index, subviews.containsIndex(index) {
//            return
//        }
//        curIndex = index
//        UIView.animate(withDuration: 0.2) {
//            var curX: CGFloat = 0
//            for (tmpIndex, item) in self.subviews.enumerated() {
//                if tmpIndex == index {
//                    item.width = self.configure.itemSelectedW
//                    item.backgroundColor = self.configure.selectedColor
//                } else {
//                    item.width = self.configure.itemW
//                    item.backgroundColor = self.configure.color
//                }
//                item.x = curX
//                curX = item.frame.maxX + self.configure.itemSpacing
//            }
//        }
//    }
//}
//
//struct MMPageControlConfigure {
//
//    var count: Int = 0
//
//    var color: UIColor = UIColor.hexStringToColor("D8D8D8")
//
//    var selectedColor: UIColor = UIColor.hexStringToColor("208CF7")
//
//    var itemH: CGFloat = 4
//
//    var itemW: CGFloat = 4
//
//    var itemSelectedW: CGFloat = 12
//
//    var itemSpacing: CGFloat = 4
//
//    var itemCornerRaidus: CGFloat = 2
//
//}
