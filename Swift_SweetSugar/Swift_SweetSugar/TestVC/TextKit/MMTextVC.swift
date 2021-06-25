//
//  MMTextVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/3.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMTextVC: UIViewController {
    @IBOutlet weak var xibTextView: UITextView!
    
    var storage: NSTextStorage = NSTextStorage()
    
    var container: NSTextContainer = NSTextContainer()
    
    var layout: NSLayoutManager = NSLayoutManager()

    lazy var textView: UITextView = {
//        container.size = CGSize(width: 100,height: 200)
        layout.addTextContainer(container)
        storage.addLayoutManager(layout)
        let item = UITextView(frame: CGRect(x: 10, y: 300, width: 100, height: 200), textContainer: container)
        item.isScrollEnabled = true
        item.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(textView)
        
        textView.text = """
        In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        """
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mm_printLog(layout)
        
        mm_printLog(container)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
