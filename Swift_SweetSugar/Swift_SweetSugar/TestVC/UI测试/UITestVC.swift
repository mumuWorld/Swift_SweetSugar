//
//  UITestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import YYText
import SnapKit

func creat(_ block:(UIButton)->()) -> UIButton {
    let btn = UIButton()
    block(btn)
    return btn
}

class UITestVC: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView_h: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var leftView: UIView!
    
    let bar: UIButton = creat { (btn) in
        mm_printLog("测试调用")
        btn.backgroundColor = .black
        btn.addTarget(self, action: #selector(handleClick(sender:)), for: .touchUpInside)
    }
    
    var attrText: YYLabel = {
        let label = YYLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .cyan
        return label
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        shadowView.layer.cornerRadius = 24
      //        layer.shadowColor = UIColor(hex: 0x3C4D59, alpha: 0.9).cgColor
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 1
        
//        shadowView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        
        let shadowSub = UIView(frame: CGRect(x: 0, y: -10, width: 30, height: 30))
        shadowSub.backgroundColor = .red
        shadowView.addSubview(shadowSub)
        
        shadowView.mm_y = 100
        
        let line: MMDottedLine = MMDottedLine()
        line.mm_size = CGSize(width: 100, height: 10)
        line.test()
        line.mm_y = 100
        view.addSubview(line)
        
        view.addSubview(attrText)
        
        shadowView.layer.anchorPoint = CGPoint(x: 1, y: 0)
        view.layoutIfNeeded()
        DispatchQueue.main.async {
            let origin = self.shadowView.origin
            self.shadowView.origin = CGPoint(x: origin.x + self.shadowView.mm_width * 0.5, y: origin.y - self.shadowView.mm_height * 0.5)
        }
        addConstants()
    }
    
    var show = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        handleClick(sender: bar)
        if show {
            dismiss()
        } else {
            showAnimation()
        }
        show = !show
    }
    
    func setupAttr() -> Void {
        let str = "Your project does not explicitly specify the CocoaPodsmassdfssdfter specs repo. Since CDN is now used as the default, you may safely remove it from your repos directory via `pod repo remove master`. To suppress this warning please add `warn_for_unused_master_specs_repo => false` to your Podfile"
        
        let attr = NSMutableAttributedString(string: str)
        attr.addAttribute(NSAttributedString.Key.font, value: attrText.font, range: str.mm_range())
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_voice_3"), for: .normal)
        btn.mm_size = CGSize(width: 18, height: 18)
        
        let attach = NSAttributedString.yy_attachmentString(withContent: btn, contentMode: .center, attachmentSize: btn.mm_size, alignTo: attrText.font, alignment: .center)
        
        attr.append(attach)
        let container = YYTextContainer(size: CGSize(width: 200, height: .max))
        
        let layout = YYTextLayout(container: container, text: attr)
        
        if let lines = layout?.lines, (layout?.lines.count ?? 0) > 20 {
            let maxRange = lines[1]
            guard var subAttr = attr.attributedSubstring(from: NSRange(location: 0, length: NSMaxRange(maxRange.range))).mutableCopy() as? NSMutableAttributedString else {
                return
            }
            let suffixAttr = beyondAttach()
            //判断是否有换行
            let tmpSubAttr = subAttr.mutableCopy() as! NSMutableAttributedString
            tmpSubAttr.append(suffixAttr)
            let tmpLayout = YYTextLayout(container: container, text: tmpSubAttr)
            
            var fitLayout: YYTextLayout?
            
            if (tmpLayout?.lines.count ?? 0) > 2 {
                //多减去1个字符
                subAttr.replaceCharacters(in: NSRange(location: subAttr.length - suffixAttr.length - 1, length: suffixAttr.length), with: suffixAttr)
                fitLayout = YYTextLayout(container: container, text: subAttr)
            } else {
                fitLayout = tmpLayout
                subAttr = tmpSubAttr
            }
            
            attrText.attributedText = subAttr
            attrText.mm_x = 50
            attrText.mm_y = 200
            attrText.mm_size = CGSize(width: 200, height: fitLayout?.textBoundingSize.height ?? 0)
//        }
        } else {
        attrText.attributedText = attr
//                    attrText.textLayout = layout
        attrText.mm_x = 50
                   attrText.mm_y = 200
        attrText.mm_size = CGSize(width: 200, height: layout?.textBoundingSize.height ?? 0)
    }
        mm_printLog("")
    }

    func beyondAttach() -> NSAttributedString {
        let attr = NSMutableAttributedString(string: " ...")
        attr.addAttribute(NSAttributedString.Key.font, value: attrText.font, range: attr.yy_rangeOfAll())
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_voice_3"), for: .normal)
        btn.mm_size = CGSize(width: 18, height: 18)
        let attach = NSAttributedString.yy_attachmentString(withContent: btn, contentMode: .center, attachmentSize: btn.mm_size, alignTo: attrText.font, alignment: .center)

        attr.append(attach)
        
        return attr
    }
    var str = "Your project does not explicitly specify"
    @objc func handleClick(sender: UIButton) {
        
        str += " a"
        let attr = getInputAttr(input: str, font: UIFont.systemFont(ofSize: 20))
        
        let number = attr.numberOfLine(width: 150)
        
        mm_printLog("点击了->\(number)")
        
        textView.attributedText = attr
    }
}


extension UITestVC {
    func getInputAttr(input: String, font: UIFont) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5.0
        let attribute = NSAttributedString(string: input,
                                           attributes: [
                                            NSAttributedString.Key.paragraphStyle: paragraph,
                                            NSAttributedString.Key.font: font as Any,
//                                            NSAttributedString.Key.kern: 0.01
                                           ])
        return attribute
    }
    
    func showAnimation() -> Void {
//        view.layoutIfNeeded()
//        let transfrom = CGAffineTransform(scaleX: 0.4, y: 0.4)
//        shadowView.transform = transfrom
//        let origin = shadowView.origin
//
//        shadowView.origin = CGPoint(x: origin.x + shadowView.mm_width * 0.5, y: origin.y - shadowView.mm_height * 0.5)

//        shadowView.origin = CGPoint(x: 100, y: 200)
        let base = CABasicAnimation(keyPath: "transform.scale")
        base.fromValue = 0.4
        base.toValue = 1

//        base.
        shadowView.layer.add(base, forKey: "scale")
   
    }
    func dismiss() -> Void {
        let base = CABasicAnimation(keyPath: "transform.scale")
        base.fromValue = 1
        base.toValue = 0.4
        
//        base.
        shadowView.layer.add(base, forKey: "dismiss")
    }
    
    func addConstants() -> Void {
        topView.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.left.equalTo(leftView.snp.right).offset(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(leftView)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(10)
            make.right.equalTo(-10)
            make.left.equalTo(leftView.snp.right).offset(10)
            make.top.equalTo(topView.snp.bottom).offset(10)
        }
    }
}
