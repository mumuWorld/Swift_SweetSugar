////
////  YDImageCompressor.swift
////  Swift_SweetSugar
////
////  Created by 杨杰 on 2025/8/11.
////  Copyright © 2025 Mumu. All rights reserved.
////
//

import UIKit
import Accelerate
//
//public enum YDImageCompressor {
//    /// 压缩图片，返回压缩后的 UIImage
//    /// - 参数 image: 原始 UIImage
//    /// - 返回值: 压缩后的 UIImage，如果失败则返回 nil
//    public static func compress(image: UIImage) -> UIImage? {
//        guard let cgImage = image.cgImage else { return nil }
//
//        let maxTileCount = 4  // 2x2 分块
//        let targetSSIM: Float = 0.97
//
//        // 先分析图片分块权重（可扩展为边缘强度等）
//        let analysis = YDImageAnalysis.analyze(image: cgImage, tileCount: maxTileCount)
//
//        // 对每个分块单独压缩，合成最后图片
//        let compressedTiles = analysis.tiles.compactMap { tile -> CGImage? in
//            // 裁剪分块图
//            guard let tileCg = YDImageUtils.cropImage(cgImage, rect: tile.rect) else { return nil }
//            // 压缩分块图到满足 SSIM
//            if let compressedData = try? YDImageCompression.compressCGImage(tileCg, targetSSIM: targetSSIM),
//               let compressedCg = UIImage(data: compressedData)?.cgImage {
//                return compressedCg
//            }
//            return tileCg // 压缩失败用原图
//        }
//
//        // 拼接分块图，返回完整 UIImage
//        return YDImageUtils.mergeTiles(compressedTiles, originalSize: CGSize(width: cgImage.width, height: cgImage.height), tileCount: maxTileCount)
//    }

//}


public class YDImageCompressor {
    
    /// 压缩图片主入口
    /// - Parameters:
    ///   - image: 原始图片
    ///   - maxLength: 最大边长限制，避免过大
    ///   - tileSize: 分块大小，默认为 128
    ///   - maxFileSizeKB: 目标最大体积KB
    /// - Returns: 压缩后图片或nil
    public static func compress(image: UIImage,
                                maxLength: CGFloat = 1664,
                                tileSize: Int = 128,
                                maxFileSizeKB: Int = 200) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        
        // 1. 缩放图片至最大边长限制
        let scaledImage = resize(image: image, maxLength: maxLength)
        guard let scaledCgImage = scaledImage.cgImage else { return nil }
        
        // 2. 拆分分块并压缩每块（多质量档位尝试）
        let width = scaledCgImage.width
        let height = scaledCgImage.height
        
        // 这里为了简化，先不拆块，只用整体多档压缩模拟效果
        // 真实拆块需要像素操作，代码复杂，此处演示思路
        return compressWithQualityLoop(image: scaledImage, maxFileSizeKB: maxFileSizeKB)
    }
    
    /// 缩放图片至最大边长限制
    private static func resize(image: UIImage, maxLength: CGFloat) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let scale = min(1.0, maxLength / max(width, height))
        let newSize = CGSize(width: width * scale, height: height * scale)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resized = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
        
        return resized
    }
    
    /// 多档质量压缩尝试，直到满足体积需求
    private static func compressWithQualityLoop(image: UIImage, maxFileSizeKB: Int) -> UIImage? {
        let minQuality: CGFloat = 0.1
        var quality: CGFloat = 0.9
        
        while quality >= minQuality {
            if let data = image.jpegData(compressionQuality: quality) {
                let sizeKB = data.count / 1024
                if sizeKB <= maxFileSizeKB {
                    return UIImage(data: data)
                }
            }
            quality -= 0.1
        }
        // 质量最低仍超限，返回最低质量图
        return image.jpegData(compressionQuality: minQuality).flatMap { UIImage(data: $0) }
    }
}
