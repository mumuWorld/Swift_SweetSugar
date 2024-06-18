//
//  MMBlockClass.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/10/20.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

class MMBlockClass {
    
    var block1: (() -> Void)?
    
    func test1() {
        block1 = {
            print("test->测试持有self1:")
            MMCommonShare.shareInstance.blockClass2.block1 = { [weak self] in
                guard let self = self else { return }
                print("test->测试持有self2:\(self)")
            }
            // 跟下面block调用没有关系
            // MMCommonShare.shareInstance.blockClass2.block1?()
        }
        // 跟下面block调用有关系
        block1?()
    }
    
    deinit {
        mm_printLog("test->释放 MMBlockClass")
    }
}

class MMBlockClass2 {
    
    var block1: (() -> Void)?
    
    deinit {
        mm_printLog("test->释放 MMBlockClass2")
    }
}


class MMNSObject: NSObject {
    var name: String?
}
