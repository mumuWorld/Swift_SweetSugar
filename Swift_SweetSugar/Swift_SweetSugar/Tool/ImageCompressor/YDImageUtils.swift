////
////  YDImageUtils.swift
////  Swift_SweetSugar
////
////  Created by 杨杰 on 2025/8/11.
////  Copyright © 2025 Mumu. All rights reserved.
////
//
//import UIKit
//import CoreGraphics
//import ImageIO
//import MobileCoreServices
//
//public enum YDImageUtils {
//    /// 裁剪图片
//    public static func cropImage(_ cgImage: CGImage, rect: CGRect) -> CGImage? {
//        return cgImage.cropping(to: rect)
//    }
//
//    /// 重新缩放图片
//    public static func resizeCGImage(_ cgImage: CGImage, to size: CGSize) -> CGImage? {
//        let width = Int(size.width)
//        let height = Int(size.height)
//        guard width > 0 && height > 0 else { return nil }
//
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bytesPerRow = width * 4
//        guard let context = CGContext(data: nil,
//                                      width: width,
//                                      height: height,
//                                      bitsPerComponent: 8,
//                                      bytesPerRow: bytesPerRow,
//                                      space: colorSpace,
//                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//        else { return nil }
//
//        context.interpolationQuality = .high
//        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
//        return context.makeImage()
//    }
//
//    /// 生成 JPEG Data
//    public static func jpegData(from cgImage: CGImage, quality: CGFloat) -> Data? {
//        let mutableData = CFDataCreateMutable(nil, 0)!
//        guard let destination = CGImageDestinationCreateWithData(mutableData, kUTTypeJPEG, 1, nil) else { return nil }
//        let options = [kCGImageDestinationLossyCompressionQuality: quality] as CFDictionary
//        CGImageDestinationAddImage(destination, cgImage, options)
//        guard CGImageDestinationFinalize(destination) else { return nil }
//        return mutableData as Data
//    }
//
//    /// 提取灰度 patch，返回 Float 数组（方便 SSIM 计算）
//    public static func extractGrayPatch(from cgImage: CGImage, x: Int, y: Int, w: Int, h: Int) -> [Float]? {
//        guard w > 0 && h > 0 else { return nil }
//
//        let colorSpace = CGColorSpaceCreateDeviceGray()
//        let bytesPerRow = w
//
//        guard let context = CGContext(data: nil,
//                                      width: w,
//                                      height: h,
//                                      bitsPerComponent: 8,
//                                      bytesPerRow: bytesPerRow,
//                                      space: colorSpace,
//                                      bitmapInfo: CGImageAlphaInfo.none.rawValue)
//        else { return nil }
//
//        // 注意 CoreGraphics 坐标系，绘制区域需偏移
//        context.draw(cgImage, in: CGRect(x: -x, y: -y, width: cgImage.width, height: cgImage.height))
//
//        guard let data = context.data else { return nil }
//        let ptr = data.assumingMemoryBound(to: UInt8.self)
//        var out = [Float](repeating: 0, count: w * h)
//        for i in 0..<(w * h) {
//            out[i] = Float(ptr[i])
//        }
//        return out
//    }
//
//    /// 合成多个分块图片，返回整张 UIImage
//    public static func mergeTiles(_ tiles: [CGImage], originalSize: CGSize, tileCount: Int) -> UIImage? {
//        guard tiles.count == tileCount else { return nil }
//
//        let cols = Int(sqrt(Double(tileCount)))
//        let rows = cols
//
//        let tileWidth = Int(originalSize.width) / cols
//        let tileHeight = Int(originalSize.height) / rows
//
//        UIGraphicsBeginImageContextWithOptions(originalSize, false, 1.0)
//        defer { UIGraphicsEndImageContext() }
//
//        for (index, tile) in tiles.enumerated() {
//            let col = index % cols
//            let row = index / cols
//            let x = CGFloat(col * tileWidth)
//            let y = CGFloat(row * tileHeight)
//            let rect = CGRect(x: x, y: y, width: CGFloat(tile.width), height: CGFloat(tile.height))
//            UIImage(cgImage: tile).draw(in: rect)
//        }
//
//        let merged = UIGraphicsGetImageFromCurrentImageContext()
//        return merged
//    }
//}
