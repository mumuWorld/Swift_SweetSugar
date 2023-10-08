//
//  MMSyntaxTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/7/14.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

protocol SayYES {
    func sayYes()
}

extension SayYES {
    func sayYes() {
        print("SayYES: yes")
    }
}

protocol SayNO {
    func sayYes()
}

extension SayNO {
    func sayYes() {
        print("NO: yes")
    }
}

class MMSyntaxTool {
    
}

extension MMSyntaxTool: SayYES, SayNO {
    // 只会打印 test
    func sayYes() {
        mm_printLog("test")
    }
}
