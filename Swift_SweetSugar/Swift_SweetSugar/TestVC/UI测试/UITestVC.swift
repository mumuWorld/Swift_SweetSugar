//
//  UITestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class UITestVC: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    
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
