//
//  MMAnyTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/7/7.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation

struct firstNetworking: Networking {
    @available(iOS 13.0.0, *)
    func fetchPosts() async throws -> [Post]{
        return []
    }
}

struct secondNetworking: Networking {
    @available(iOS 13.0.0, *)
    func fetchPosts() async throws -> [Post]{
        return []
    }
}

protocol Networking {
    @available(iOS 13.0.0, *)
    func fetchPosts() async throws -> [Post]
    // ...
}

struct Post {
    
}

struct PostsDataSource<Network: Networking> {
    var networking: Network
    // ...
}

func test() -> Void {
    var post = PostsDataSource(networking: firstNetworking())
    //“Cannot assign value of type 'secondNetworking' to type 'firstNetworking‘”jj
//    post.networking = secondNetworking() // 编译报错类型不匹配
}
