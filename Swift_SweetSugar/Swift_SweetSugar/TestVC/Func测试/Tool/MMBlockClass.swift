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
    
    deinit {
        mm_printLog("test->释放")
    }
}

class MMBlockClass2 {
    
    var block1: (() -> Void)?
    
    deinit {
        mm_printLog("test->释放")
    }
}
