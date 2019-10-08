//
//  TreeSolution.swift
//  Swift_SweetSugar
//
//  Created by mumu on 2019/9/24.
//  Copyright © 2019 Mumu. All rights reserved.
//

import Foundation

class TreeSolution {
    
    /// 98. 验证二叉搜索树
    /// https://leetcode-cn.com/problems/validate-binary-search-tree/
    var last: Int?
    func isValidBST(_ root: TreeNode?) -> Bool {
        // 思路1 中序遍历 是否升序
        if root == nil {
            return true
        }
        if !isValidBST(root?.left) {
            return false
        }
        
        if last != nil, root!.val <= last! {
            return false
        }
        last = root!.val
        
        if !isValidBST(root?.right) {
            return false
        }
        
        return true
    }
}
