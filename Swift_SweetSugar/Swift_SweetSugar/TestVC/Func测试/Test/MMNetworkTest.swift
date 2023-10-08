//
//  MMNetworkTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/8/3.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation


class MMNetworkTest {
    
    static let shared: MMNetworkTest = MMNetworkTest()
    
    func test() {
        guard let url = URL(string: "http://localhost:9999/") else { return }
        var req = URLRequest(url:url)
        req.httpMethod = "GET"
        
        
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: req) { data, response, error in
            print("test->\(data), \(response), \(error)")
        }
        
        task.resume()
    }
}
