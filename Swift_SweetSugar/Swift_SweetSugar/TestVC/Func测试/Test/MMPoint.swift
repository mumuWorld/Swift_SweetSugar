//
//  MMPoint.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/8/16.
//  Copyright © 2021 Mumu. All rights reserved.
//

import Foundation

struct MMPoint {
    var x, y: Float
}

struct TestJsonStruct: Codable {
    var text: String?
}

class TestJsonClass: Codable {
    var text: String?
}

protocol MMTestProtocol: UIView { }

class MMExampleCardView: UIView, MMTestProtocol {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MMSwiftUICell<Card: MMTestProtocol>: UIView {
    
    func setupSubViews() {
        let cardType = Swift.type(of: Card.self)
        print("Card type: \(cardType)")
        
        let cardView = Swift.type(of: MMExampleCardView.self)
        
        if cardType == cardView {
            print("test->type: 对的1") //正确
        }
        if cardType is MMExampleCardView {
            print("test->type: 对的11") // 错误
        }
        if cardType is MMExampleCardView.Type {
            print("test->type: 对的11") // 错误
        }
        if Card.self is MMExampleCardView {
            print("test->type: 对的2") // 错误
        }
        if Card.self is MMExampleCardView {
            print("test->type: 对的2") // 错误
        }
        if !(Card.self is MMExampleCardView.Type) {
            //正确
        }
    }
}
    
