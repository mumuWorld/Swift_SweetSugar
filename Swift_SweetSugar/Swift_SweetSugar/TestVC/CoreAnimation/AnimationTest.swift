//
//  AnimationTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/2/10.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

/// 结果页入口
public class YDDOCRKeyInfoEntryView: UIView {
    
    @objc public var pushToKeyInfoVC: (() -> Void)?
    
    lazy var entryBtn: UIButton = {
        let item = UIButton(type: .custom)
        item.setTitle("点击进入", for: .normal)
        item.backgroundColor = .red
        //        item.setImage(Res.image(named: "ic_member_scan"), for: .normal)
        item.addTarget(self, action: #selector(handleEntry(sender:)), for: .touchUpInside)
        //        item.yd_cornerRadius = 20
        return item
    }()
    
    lazy var entryTipView: UIView = {
        let item = UIView()
        item.layer.masksToBounds = true
        return item
    }()
    
    lazy var tipImgView: UIImageView = {
        let item = UIImageView()
        item.image = UIImage(named: "ic_mark_tip_bg")
        item.layer.anchorPoint = CGPoint(x:1.0, y: 0.5)
        return item
    }()
    
    lazy var tipPointView: UIView = {
        let item = UIView()
        //        item.backgroundColor = CommonColors.shared.color_text_white.withAlphaComponent(0.3)
        item.layer.cornerRadius = 2.5
        return item
    }()
    
    lazy var tipLabel: UILabel = {
        let item = UILabel()
        item.text = "提取文中划线笔记"
        //        item.font = CommonFonts.shared.font_h6
        item.textColor = .white
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(entryBtn)
        addSubview(entryTipView)
        entryTipView.addSubview(tipImgView)
        tipImgView.addSubview(tipPointView)
        tipImgView.addSubview(tipLabel)
        
        entryBtn.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.width.height.equalTo(40)
        }
        entryTipView.snp.makeConstraints { make in
            make.trailing.equalTo(entryBtn.snp.leading).offset(-4)
            make.leading.equalToSuperview()
            make.centerY.equalTo(entryBtn)
            make.width.equalTo(375)
            make.height.equalTo(32)
        }
        tipImgView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(145 * 0.5 - 8)
            make.top.height.equalToSuperview()
            make.width.equalTo(145)
        }
        tipPointView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(5)
        }
        tipLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalTo(tipPointView.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
        }
//        entryTipView.transform = CGAffineTransformMakeScale(0.1, 1)
//        entryTipView.alpha = 0
//        layoutIfNeeded()
//        let animation = CABasicAnimation(keyPath: "transform.scale.x")
//        animation.fromValue = 0
//        animation.toValue = 1
//        animation.autoreverses = false
//        animation.duration = 3.0
//        entryTipView.layer.add(animation, forKey: "tsx")
        self.tipImgView.alpha = 0.5
//        self.tipImgView.transform = CGAffineTransform(translationX: 200, y: 0)
        self.tipImgView.layer.transform = CATransform3DMakeScale(0.1, 1, 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleEntry(sender: UIButton) {
        print("进入结果页")
        pushToKeyInfoVC?()
    }
    
    func show() {
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = CATransform3DMakeScale(0, 1, 1)
        animation.toValue = CATransform3DMakeScale(1, 1, 1)
        animation.duration = 1.0
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        entryTipView.layer.add(animation, forKey: "tsx")
//        self.layer.masksToBounds = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 8) {
            self.tipImgView.layer.transform = CATransform3DIdentity
            self.tipImgView.alpha = 1.0
//            self.layoutIfNeeded()
        }
//        UIView.animate(withDuration: 3) {
//            self.entryTipView.transform = .identity
//        }
        let showCount = UserDefaults.standard.integer(forKey: "kYDOCRKeyInfoEntryTipShowCount")
        if showCount < 6 {
            //展示动画
        }
        
    }
}
