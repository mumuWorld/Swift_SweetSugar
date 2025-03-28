//
//  MMTextVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/3.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import SnapKit
import YYText
import Lottie

class MMTextVC: UIViewController {
    @IBOutlet weak var xibTextView: UITextView!
    
    var storage: NSTextStorage = NSTextStorage()
    
//    var container: MMTextContainer = MMTextContainer(size: CGSize(300, 200))
//    var container: NSTextContainer = NSTextContainer()
        var mmContainer: NSTextContainer = MMTextContainer()

    var layout: NSLayoutManager = NSLayoutManager()
    
    var mmLayoutManager: MMLayoutManager = MMLayoutManager()


    lazy var textView: UITextView = {
//        container.size = CGSize(width: 100,height: 200)
        mmLayoutManager.addTextContainer(mmContainer)

        storage.addLayoutManager(mmLayoutManager)

//        container.exclusionPaths = [UIBezierPath(roundedRect: CGRect(x: 10, y: 50, width: 100, height: 100), cornerRadius: 50)]
//        let item = UITextView(frame: CGRect(x: 10, y: 300, width: 300, height: 200), textContainer: mmContainer)
        let item = UITextView()
//        let item = MMHookTextView(frame: .zero)
        item.font = UIFont.systemFont(ofSize: 20)
        item.textColor = UIColor.red.withAlphaComponent(0.5)
        item.tintColor = UIColor.green
        item.isScrollEnabled = true
        item.returnKeyType = .search
        item.isEditable = true
        item.keyboardDismissMode = .onDrag
        item.textContainer.lineFragmentPadding = 0
        item.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        item.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        item.textContainer.lineBreakMode = .byWordWrapping
        item.delegate = self
        return item
    }()
    
    lazy var textField: UITextField = {
        let item = UITextField()
        item.borderStyle = .line
        item.delegate = self
        return item
    }()

    lazy var floatInput: MMFloatTextView = {
        let item = MMFloatTextView()
        return item
    }()
    
    lazy var yyTextView: YYTextView = {
        let item = YYTextView()
        item.isSelectable = true
        item.placeholderText = "我是YYText"
        item.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addUITextView()
//        addTextField()
//        addYYTextView()
//        getText()
//        pasteControl()
//        customMenu()
//        addObserve()
    }
    
    func addYYTextView() {
        view.addSubview(yyTextView)
        yyTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(230)
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
//        let animationView = AnimationView(name: "anim_search_loop_light", bundle: .main) // 替换 "yourAnimationName" 为你的动画文件名（不含扩展名）
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .loop
//        animationView.play()
//        animationView.mm_size = CGSize(30, 30)
//        animationView.origin = CGPoint(x: 100, y: 100)
//        view.addSubview(animationView)
        
        addLottie()
    }
    
    func addLottie() {
        let font = UIFont.systemFont(ofSize: 24)
        let text = NSMutableAttributedString(string: "测试文本呢神鼎飞丹砂测试文本呢神鼎飞丹砂测试文本呢神鼎飞丹砂", attributes: [.font: font])
        
        let animationView = AnimationView(name: "result_trans_loading_loop", bundle: .main) // 替换 "yourAnimationName" 为你的动画文件名（不含扩展名）
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.mm_size = CGSize(18, 4)
        
        let attachText = NSMutableAttributedString.yy_attachmentString(withContent: animationView, contentMode: .topRight, attachmentSize: CGSize(20, 8), alignTo: font, alignment: .bottom)
        
        text.append(attachText)
        
        yyTextView.attributedText = text
    }
    
    func addTextField() {
        view.addSubview(textField)
        textField.frame = CGRect(x: 20, y: 340, width: 300, height: 30)
    }
    
    func addUITextView() {
        //        layout.delegate = self
                view.addSubview(textView)
        //        view.addSubview(textField)
                let text = """
                我在好几篇小说中都提到过一座废弃的古园，实际就是地坛1。许多年前旅游业还没有开展，园子荒芜冷落得如同一片野地，很少被人记起。
                地坛离我家很近。或者说我家离地坛很近。总之，只好认为这是缘分。地坛在我出生前四百多年就座落在那儿了，而自从我的祖母年轻时带着我父亲来到北京，就一直住在离它不远的地方一五十多年间搬过几次家，可搬来搬去总是在它周围，而且是越搬离它越近了。我常觉得这中间有着宿命的味道：仿佛这古园就是为了等我，而历尽沧桑在那儿等待了四百多年。
                它等待我出生，然后又等待我活到最狂妄的年龄上忽地残废了双腿。四百多年里，它一面剥蚀了古殿檐头浮夸的琉璃，淡褪了门壁上炫耀的朱红，坍圮2了一段段高墙又散落了玉砌雕栏，祭坛四周的老柏树愈见苍幽，到处的野草荒藤也都茂盛得自在坦荡。这时候想必我是该来了。十五年前的一个下午，我摇着轮椅进入园中，它为一个失魂落魄的人把一切都准备好了。那时，太阳循着亘古3不变的路途正越来越大，也越红。在满园弥漫的沉静光芒中，一个人更容易看到时间，并看见自己的身影。
                自从那个下午我无意中进了这园子，就再没长久地离开过它。我一下子就理解了它的意图。正如我在一篇小说中所说的：“在人口密聚的城市里，有这样一个宁静的去处，像是上帝的苦心安排。”
                两条腿残废后的最初几年，我找不到工作，找不到去路，忽然间几乎什么都找不到了，我就摇了轮椅总是到它那儿去，仅为着那儿是可以逃避一个世界的另一个世界。我在那篇小说中写道：“没处可去我便一天到晚耗在这园子里。跟上班下班一样，别人去上班我就摇了轮椅到这儿来。园子无人看管，上下班时间有些抄近路的人们从园中穿过，园子里活跃一阵，过后便沉寂下来。”“园墙在金晃晃的空气中斜切下一溜荫凉，我把轮椅开进去，把椅背放倒，坐着或是躺着，看书或者想事，撅一杈树枝左右拍打，驱赶那些和我一样不明白为什么要来这世上的小昆虫。”“蜂儿如一朵小雾稳稳地停在半空；蚂蚁摇头晃脑捋着触须，猛然间想透了什么，转身疾行而去；瓢虫爬得不耐烦了，累了祈祷一回便支开翅膀，忽悠一下升空了；树干上留着一只蝉蜕，寂寞如一间空屋；露水在草叶上滚动、聚集，压弯了草叶轰然坠地摔开万道金光。”“满园子都是草木竞相生长弄出的响动，窸窸窣窣窸窸窣窣片刻不息。”这都是真实的记录，园子荒芜但并不衰败。
                除去几座殿堂我无法进去，除去那座祭坛我不能上去而只能从各个角度张望它，地坛的每一棵树下我都去过，差不多它的每一米草地上都有过我的车轮印。无论是什么季节，什么天气，什么时间，我都在这园子里呆过。有时候呆一会儿就回家，有时候就呆到满地上都亮起月光。记不清都是在它的哪些角落里了。我一连几小时专心致志地想关于死的事，也以同样的耐心和方式想过我为什么要出生。这样想了好几年，最后事情终于弄明白了：一个人，出生了，这就不再是一个可以辩论的问题，而只是上帝交给他的一个事实；上帝在交给我们这件事实的时候，已经顺便保证了它的结果，所以死是一件不必急于求成的事，死是一个必然会降临的节日。这样想过之后我安心多了，眼前的一切不再那么可怕。比如你起早熬夜准备考试的时候，忽然想起有一个长长的假期在前面等待你，你会不会觉得轻松一点？并且庆幸并且感激这样的安排？
                }
                """
        //        textView.textContainer.exclusionPaths = [UIBezierPath(roundedRect: CGRect(x: 10, y: 50, width: 100, height: 100), cornerRadius: 50)]
        //        storage.replaceCharacters(in: NSRange(location: 0, length: 0), with: text)
                
                textView.text = text
                
        //        textView.layoutManager.addTextContainer(container)
                textView.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview().inset(20)
                    make.top.equalToSuperview().offset(kNaviBarHeight + 20)
                    make.height.equalTo(300)
                }
        //        textView.frame = CGRect(x: 20, y: 230, width: 300, height: 100)
        //        textField.frame = CGRect(x: 20, y: 340, width: 300, height: 30)
    }
    
    func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: UIApplication.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(sender:)), name: UIApplication.keyboardDidHideNotification, object: nil)

    }
    
    @objc func handleNotification(sender: Notification) {
//        [AnyHashable(\"UIKeyboardIsLocalUserInfoKey\"): 1, AnyHashable(\"UIKeyboardAnimationDurationUserInfoKey\"): 0.25, AnyHashable(\"UIKeyboardAnimationCurveUserInfoKey\"): 7, AnyHashable(\"UIKeyboardFrameBeginUserInfoKey\"): NSRect: {{0, 812}, {375, 282}}, AnyHashable(\"UIKeyboardCenterBeginUserInfoKey\"): NSPoint: {187.5, 953}, AnyHashable(\"UIKeyboardBoundsUserInfoKey\"): NSRect: {{0, 0}, {375, 357}}, AnyHashable(\"UIKeyboardCenterEndUserInfoKey\"): NSPoint: {187.5, 633.5}, AnyHashable(\"UIKeyboardFrameEndUserInfoKey\"): NSRect: {{0, 455}, {375, 357}}]
        mm_printLog("test->\(sender.name), \(sender.userInfo)")
        guard let boardRect = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        switch sender.name {
        case UIApplication.keyboardWillShowNotification:
            floatInput.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(boardRect.height)
            }
        case UIApplication.keyboardWillHideNotification:
            floatInput.snp.updateConstraints { make in
                make.bottom.equalToSuperview()
            }
        default:
            break
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
//        mm_printLog(layout)
//        mm_printLog(container)
//        addFloatInput()
    }
    
    func addFloatInput() {
        view.addSubview(floatInput)
        floatInput.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalToSuperview()
        }
        floatInput.textView.becomeFirstResponder()
    }
    
    
    func customMenu() {
            
        let menu = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(handleMyCopy(sender:)))
        let testItem = UIMenuItem(title: "测试", action: #selector(handleTest(sender:)))
        menu.menuItems = [copyItem, testItem]
        
    }
    
    
    func pasteControl() {
        if #available(iOS 16.0, *) {
            let confi : UIPasteControl.Configuration = UIPasteControl.Configuration()
            confi.cornerStyle = .capsule
            confi.displayMode = .iconAndLabel
            confi.baseForegroundColor = UIColor.blue
            confi.baseBackgroundColor = UIColor.red
            let control = UIPasteControl(configuration: confi)
            
            view.addSubview(control)
            control.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(10)
                make.top.equalToSuperview().offset(200)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getText() {
        do {
            let path = Bundle.main.path(forResource: "textview", ofType: "json")!
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .alwaysMapped)
            if #available(iOS 15.0, *) {
                if let dict = try JSONSerialization.jsonObject(with: data, options: .json5Allowed) as? [String: Any] {
                    mm_printLog(dict)
                }
            } else {
                // Fallback on earlier versions
            }
            
            let model = try JSONDecoder().decode(MMTextJson.self, from: data)
            let str = String(data: data, encoding: .utf8)
            textView.text = str
        } catch let e {
            mm_printLog(e)
        }
    }

}

extension MMTextVC {
    @objc func handleMyCopy(sender: AnyObject) {
        mm_printLog("test->\(sender)")
        
    }
    
    @objc func handleTest(sender: AnyObject) {
        mm_printLog("test->\(sender)")
        
    }
}

struct MMTextJson: Decodable {
    var input: String = "" {
        didSet {
            mm_printLog("text-> didSet")
        }
    }
    var test: String?
}
extension MMTextVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mm_printLog("test->return")
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        mm_printLog("test->didEND, reason:\(reason.rawValue)")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        mm_printLog("test->repceing: \(string)")
        return true
    }
}
extension MMTextVC: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        mm_printLog("test->DidEnd") 
        textView.endEditing(true)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        mm_printLog("test->shouldEnd")
        
        self.textView.snp.updateConstraints { make in
            make.height.equalTo(200)
        }
        return true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        mm_printLog("test->shouldBegin")
        self.textView.snp.updateConstraints { make in
            make.height.equalTo(500)
        }
        return true
    }
    
    /// 文字改变
    func textViewDidChange(_ textView: UITextView) {
        guard !textView.text.isEmpty else { return }
        textView.attributedText = NSAttributedString(string: textView.text, attributes: [.font: UIFont.systemFont(ofSize: 40)])
    }
}

extension MMTextVC: NSLayoutManagerDelegate {
    
    /// optional
    /// - Parameters:
    ///   - layoutManager: <#layoutManager description#>
    ///   - glyphs: <#glyphs description#>
    ///   - props: <#props description#>
    ///   - charIndexes: <#charIndexes description#>
    ///   - aFont: <#aFont description#>
    ///   - glyphRange: <#glyphRange description#>
    /// - Returns: <#description#>
//    func layoutManager(_ layoutManager: NSLayoutManager, shouldGenerateGlyphs glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSLayoutManager.GlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: UIFont, forGlyphRange glyphRange: NSRange) -> Int {
//
//    }
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return CGFloat(glyphIndex * 1);
    }
}
