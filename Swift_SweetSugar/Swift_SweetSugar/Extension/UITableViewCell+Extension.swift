//
//  UITableViewCell+Extension.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

extension UITableView {
    func mm_registerNibCell<T: UITableViewCell>(classType: T.Type)  {
        let name = String(describing: classType)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellReuseIdentifier: name)
    }
    
    func mm_registerClassCell<T: UITableViewCell>(classType: T.Type)  {
        let name = String(describing: classType)
        register(classType, forCellReuseIdentifier: name)
        
    }
    
    func mm_dequeueReusableCell<T: UITableViewCell>(classType: T.Type,indexPath: IndexPath) -> T {
        let name = String(describing: classType)
        guard let cell = dequeueReusableCell(withIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
}


extension UICollectionView {
    func mm_registerNibCell<T: UICollectionViewCell>(classType: T.Type)  {
        let name = String(describing: classType)
        let nib = UINib(nibName: name, bundle: nil)
        register(nib, forCellWithReuseIdentifier: name)
    }
    
    func mm_registerClassCell<T: UICollectionViewCell>(classType: T.Type)  {
        let name = String(describing: classType)
        register(classType, forCellWithReuseIdentifier: name)
        
    }
    
    func mm_dequeueReusableCell<T: UICollectionViewCell>(classType: T.Type,indexPath: IndexPath) -> T {
        let name = String(describing: classType)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
}
extension UIButton {
    class func buttonWith(title: String?, selectedTitle: String?, titleColor: UIColor?, selectedColor: UIColor?, image: String?, selectedImg: String?, target: Any?, selecter: Selector?,titleFont: UIFont? = nil, tag: UInt = 10) ->UIButton {
        let button = UIButton(type: .custom)
        if let tmpTit = title {
            button .setTitle(tmpTit, for: .normal)
            if let tmpColor = titleColor {
                button.setTitleColor(tmpColor, for: .normal)
            }
        }
        if let tmpTit = selectedTitle {
            if let tmpColor = selectedColor {
                button.setTitleColor(tmpColor, for: .selected)
            }
            button .setTitle(tmpTit, for: .selected)
        }
        if let font = titleFont {
            button.titleLabel?.font = font
        }
        if let tmpImg = image {
            button.setImage(UIImage.init(named: tmpImg), for: .normal)
        }
        if let tmpImg = selectedImg {
            button.setImage(UIImage.init(named: tmpImg), for: .selected)
        }
        if let tmpTarget = target,let tmpSel = selecter {
            button.addTarget(tmpTarget, action: tmpSel, for: .touchUpInside)
        }
        button.tag = Int(bitPattern: tag)
        return button
    }
}
