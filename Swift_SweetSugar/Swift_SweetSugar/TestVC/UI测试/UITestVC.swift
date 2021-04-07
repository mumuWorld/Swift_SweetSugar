//
//  UITestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import YYText

class UITestVC: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    
    var attrText: YYLabel = {
        let label = YYLabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
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
        
        let line: MMDottedLine = MMDottedLine()
        line.mm_size = CGSize(width: 100, height: 10)
        line.test()
        line.mm_y = 100
        view.addSubview(line)
        
        view.addSubview(attrText)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setupAttr()
    }
    
    func setupAttr() -> Void {
        let str = "Your project does not explicitly specify the  tCocoaPodsmaster specs repo. Since CDN is now used as the default, you may safely remove it from your repos directory via `pod repo remove master`. To suppress this warning please add `warn_for_unused_master_specs_repo => false` to your Podfile"
        
        let attr = NSMutableAttributedString(string: str)
        attr.addAttribute(NSAttributedString.Key.font, value: attrText.font, range: str.mm_range())
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_voice_3"), for: .normal)
        btn.mm_size = CGSize(width: 18, height: 18)
        
        let attach = NSAttributedString.yy_attachmentString(withContent: btn, contentMode: .center, attachmentSize: btn.mm_size, alignTo: attrText.font, alignment: .center)
        
        attr.append(attach)
        let container = YYTextContainer(size: CGSize(width: 200, height: .max))
        
        let layout = YYTextLayout(container: container, text: attr)
        
        if let lines = layout?.lines, (layout?.lines.count ?? 0) > 2 {
            let maxRange = lines[1]
            guard let subAttr = attr.attributedSubstring(from: NSRange(location: 0, length: NSMaxRange(maxRange.range))).mutableCopy() as? NSMutableAttributedString else {
                return
            }
            let suffixAttr = beyondAttach()
            //多减去两个字符
            subAttr.replaceCharacters(in: NSRange(location: subAttr.length - suffixAttr.length - 1, length: suffixAttr.length), with: suffixAttr)
            let fitLayout = YYTextLayout(container: container, text: subAttr)

            attrText.attributedText = subAttr
            attrText.textLayout = fitLayout

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
        let attr = NSMutableAttributedString(string: "...")
        attr.addAttribute(NSAttributedString.Key.font, value: attrText.font, range: attr.yy_rangeOfAll())
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_voice_3"), for: .normal)
        btn.mm_size = CGSize(width: 18, height: 18)
        let attach = NSAttributedString.yy_attachmentString(withContent: btn, contentMode: .center, attachmentSize: btn.mm_size, alignTo: attrText.font, alignment: .center)

        attr.append(attach)
        
        return attr
    }
}
