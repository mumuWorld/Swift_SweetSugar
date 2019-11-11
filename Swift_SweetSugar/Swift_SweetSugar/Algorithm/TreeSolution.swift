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
    
    
    /// 求二叉树深度

    func DepthBinaryTree(node: TreeNode?) -> Int {
        if node == nil {
            return 0
        }
        let leftDistance = DepthBinaryTree(node: node?.left)
        let rightDistance = DepthBinaryTree(node: node?.right)
        return  leftDistance > rightDistance ? leftDistance + 1 : rightDistance + 1
    }
    
    
    /// 肯定是某个节点左子树的高度加上右子树的高度加2，所以求出每个节点左子树和右子树的高度，取左右子树高度之和加2的最大值即可，假设空节点的高度为-1
    /// - Parameter node:
    func maxDistanceBinaryTree(node: TreeNode?, distance: inout Int) -> Int {
        if node == nil {
            return -1
        }
        let heightLeft = maxDistanceBinaryTree(node: node?.left, distance: &distance) + 1
        let heightRight = maxDistanceBinaryTree(node: node?.right, distance: &distance) + 1
        let addLeftRight = heightLeft + heightRight
        distance = distance > addLeftRight ? distance : addLeftRight
        return heightLeft > heightRight ? heightLeft : heightRight
    }
}
