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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

