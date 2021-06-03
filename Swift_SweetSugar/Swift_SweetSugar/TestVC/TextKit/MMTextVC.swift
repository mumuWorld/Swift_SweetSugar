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
        let item = UITextView()
        return item
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
