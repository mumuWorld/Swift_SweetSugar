//
//  MMBaseNavigationController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/3.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

}
