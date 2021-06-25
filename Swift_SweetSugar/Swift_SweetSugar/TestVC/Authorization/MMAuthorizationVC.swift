//
//  MMAuthorizationVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/6/4.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit
import Photos

class MMAuthorizationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        requetPhoto()
    }
}

extension MMAuthorizationVC {
    func requetPhoto() -> Void {
        PHPhotoLibrary.requestAuthorization { status in
            mm_printLog("权限状态=\(status.rawValue)")
        }
    }
}
