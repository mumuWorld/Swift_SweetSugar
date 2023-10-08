//
//  MMPreViewUIViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/7/10.
//  Copyright © 2023 Mumu. All rights reserved.
//

import UIKit

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
class MMPreViewUIViewController: UIViewController {

    var displayCuratedContent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
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

//
//#Preview("Library") {
//    if #available(iOS 17.0, *) {
//        let controller = MMPreViewUIViewController()
//        return controller
//    }
//    //    controller.displayCuratedContent = true
//    //        return controller
//    return UIViewController()
//}
