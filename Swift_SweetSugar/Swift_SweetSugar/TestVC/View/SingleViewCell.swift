//
//  SingleViewCell.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/4/9.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class SingleViewCell: UICollectionViewCell {

    var index: Int {
        set {
            if (newValue % 2) == 0 {
                self.contentView.backgroundColor = .cyan
            } else {
                self.contentView.backgroundColor = .red
            }
        }
        get {
            return 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
