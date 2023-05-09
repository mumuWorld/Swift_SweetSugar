//
//  MMAutoLabelTableViewCell.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/4/14.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit
import YYText

class MMAutoLabelTableViewCell: UITableViewCell {
    
    var attrText: YYLabel = {
        let label = YYLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .cyan
        label.preferredMaxLayoutWidth = ScreenWidth - 90
        return label
    }()
    
    var containerView: UIView = {
        let item = UIView()
        item.layer.cornerRadius = 12
        item.backgroundColor = .red
        return item
    }()
    
    var lineView: UIView = {
        let label = UIView()
        label.backgroundColor = .cyan
        return label
    }()
    
    var bottomLabel: MMLabel = {
        let label = MMLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .blue
        return label
    }()
    
    var _isShowAll: Bool = false
    var isShowAll: Bool {
        get { _isShowAll }
        set {
            if newValue {
                attrText.snp.remakeConstraints { make in
                    make.leading.trailing.top.equalToSuperview().inset(20)
                }
                lineView.snp.remakeConstraints { make in
                    make.top.equalTo(attrText.snp.bottom).offset(10)
                    make.height.equalTo(1)
                    make.leading.trailing.equalToSuperview()
                }
                bottomLabel.snp.remakeConstraints { make in
                    make.top.equalTo(lineView).offset(20)
                    make.leading.trailing.bottom.equalToSuperview().inset(20)
                }
                bottomLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 255), for: .vertical)
                bottomLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 777), for: .vertical)
            } else {
                attrText.snp.remakeConstraints { make in
                    make.edges.equalToSuperview().inset(20)
                }
            }
            _isShowAll = newValue
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(attrText)
        containerView.addSubview(lineView)
        containerView.addSubview(bottomLabel)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 12, bottom: 20, right: 30))
        }
        isShowAll = false
        
        attrText.text = "Users/yangjie01/Library/Developer/CoreSimulator/Devices/BE5C30E7-9629-4D3B-AE9C-A55F9110CE6B/data/Containers/Data/Application/58871640-9906-4E70-AC67-75867743C968/Library/CachesUsers/yangjie01/Library/Developer/CoreSimulator/Devices/BE5C30E7-9629-4D3B-AE9C-A55F9110CE6B/data/Containers/Data/Application/58871640-9906-4E70-AC67-75867743C968/Library/Caches"
        
        bottomLabel.text = "Swift_SweetSugar(89511) MallocStackLogging: could not tag MSL-related memory as no_footprint, so those pages will be included in process footprint Swift_SweetSugar(89511) MallocStackLogging: could not tag MSL-related memory as no_footprint, so those pages will be included in process footprint Swift_SweetSugar(89511) MallocStackLogging: could not tag MSL-related memory as no_footprint, so those pages will be included in process footprint "
        
        attrText.textLongPressAction = { [weak self] (view, attr, range, rect) in
            guard let self = self else { return }
            mm_printLog("view->\(view), \(attr)")
            let menu = UIMenuController.shared
            let item = UIMenuItem(title: "拷贝", action: #selector(handleCopy))
            menu.menuItems = [item]
            if #available(iOS 13.0, *) {
                menu.showMenu(from: self.attrText, rect: self.attrText.bounds)
            } else {
                menu.setTargetRect(self.attrText.bounds, in: self.attrText)
                menu.setMenuVisible(true, animated: true)
            }
            mm_printLog("")
        }
    }
    
    @objc func handleCopy() {
//        mm_printLog("copy: \(sender)")

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension MMAutoLabelTableViewCell: MMCellProtocol {
    func updateItem(item: MMCellItemProtocol) {
        guard let data = item.data as? Bool else { return }
        isShowAll = !data
        
        
    }
}
