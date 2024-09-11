//
//  MMAViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/8/16.
//  Copyright © 2024 Mumu. All rights reserved.
//

import UIKit

class MMAViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        // Do any additional setup after loading the view.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showBVC()
    }
    
    func showBVC() -> Void {
        let vc = MMBViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true, completion: {
            print("test->展示完成:")
        })
    }

}
