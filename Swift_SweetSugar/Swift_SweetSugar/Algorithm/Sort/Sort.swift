//
//  Sort.swift
//  Swift_SweetSugar
//
//  Created by yangjie on 2019/11/22.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class Sort<E> where E: Comparable {
    var elelments: [E]
    
    init() {
        elelments = Array()
    }
    
    init(arr: [E]) {
        elelments = arr
    }
    
    func sort() -> [E] {
        return elelments
    }
}
