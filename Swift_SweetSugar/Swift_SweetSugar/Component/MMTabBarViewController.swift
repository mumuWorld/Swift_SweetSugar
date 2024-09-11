//
//  MMTabBarViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/1/15.
//  Copyright © 2024 Mumu. All rights reserved.
//

import UIKit

class MMTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let home = HomeListVC()
        let homeNavi = MMBaseNavigationController(rootViewController: home)
        homeNavi.tabBarItem = UITabBarItem(title: "首页", image: UIImage(systemName: "list.bullet.clipboard"), selectedImage: UIImage(systemName: "heart.fill"))
        homeNavi.hidesBottomBarWhenPushed = true
        
        let mine = MMMineViewController()
        let mineNavi = MMBaseNavigationController(rootViewController: mine)
        mineNavi.tabBarItem = UITabBarItem(title: "我的", image: UIImage(systemName: "questionmark.circle"), selectedImage: UIImage(systemName: "questionmark.circle.fill"))
        mineNavi.hidesBottomBarWhenPushed = true

//        [homeNavi, mineNavi].forEach { aNav in
//            aNav.setNavigationBarHidden(true, animated: false)
//        }
        
        [home, mine].forEach { contentVC in
            contentVC.hidesBottomBarWhenPushed = false
            contentVC.view.layer.cornerRadius = 32.0
            contentVC.view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            contentVC.view.clipsToBounds = true
        }
        
        
        setViewControllers([homeNavi, mineNavi], animated: false)
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
