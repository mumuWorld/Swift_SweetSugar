//
//  WrapperTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/26.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T> {
    var key: String
    var defaultT: T!
    var wrappedValue: T! {
        get { (UserDefaults.standard.object(forKey: key) as? T) ?? defaultT }
        nonmutating set {
            mm_printLog("set")
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
    
    init(_ key: String, _ defaultT: T! = nil) {
        mm_printLog("init")
        self.key = key
        self.defaultT = defaultT
    }
}

struct UserDefaultsUnit {
    @UserDefaultWrapper("test")
    static var test: String?
}
