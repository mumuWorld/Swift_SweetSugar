//
//  HomeListItemCell.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class HomeListItemCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var routerLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var itemModel: HomeListItem? {
        didSet {
            nameLabel.text = itemModel?.showName
            routerLabel.text = itemModel?.routerVC
            descLabel.text = itemModel?.desc
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
