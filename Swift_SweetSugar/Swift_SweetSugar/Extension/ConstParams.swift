//
//  ConstParams.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/3/24.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

let NAME_SPACE: String = {() -> String in
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as! String
}()


let ScreenWidth: CGFloat = UIScreen.main.bounds.width

