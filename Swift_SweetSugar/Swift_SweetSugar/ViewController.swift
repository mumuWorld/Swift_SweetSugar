//
//  ViewController.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/4/1.
//  Copyright © 2019年 Mumu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let solution = Solution()

    @IBOutlet weak var testImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        redPin.png
//        let bundleUrl: URL = Bundle.main.url(forResource: "AMap", withExtension: "bundle")!
//        let bundle = Bundle.init(url: bundleUrl)
//        let imgPath = bundle?.path(forResource: "images/redPin.png", ofType: nil)
//        testImgView.image = UIImage.init(contentsOfFile: imgPath!)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sum2()
    }
    func sum1() -> Void {
        let nums = [-1,0,1,2,-1,-4]
        
        let result =  solution.threeSum(nums)
        print(result)
    }
    
    func sum2() -> Void {
        let str = "abcabcbb"
        let length = solution.lengthOfLongestSubstring(str)
        print(length)
    }

}

