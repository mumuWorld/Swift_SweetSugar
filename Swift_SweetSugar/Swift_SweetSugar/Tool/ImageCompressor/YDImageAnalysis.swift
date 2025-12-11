////
////  YDImageAnalysis.swift
////  Swift_SweetSugar
////
////  Created by 杨杰 on 2025/8/11.
////  Copyright © 2025 Mumu. All rights reserved.
////
//
//import CoreGraphics
//import UIKit
//
//public struct YDTile {
//    let rect: CGRect
//}
//
//public struct YDImageAnalysis {
//    public let tiles: [YDTile]
//
//    /// 分析图片并返回分块信息
//    /// - 参数 image: CGImage
//    /// - 参数 tileCount: 分块数量，默认 4（2x2）
//    /// - 返回值: 分块信息
//    public static func analyze(image: CGImage, tileCount: Int) -> YDImageAnalysis {
//        let w = image.width
//        let h = image.height
//
//        let cols = Int(sqrt(Double(tileCount)))
//        let rows = cols
//
//        var tiles: [YDTile] = []
//
//        let tileWidth = w / cols
//        let tileHeight = h / rows
//
//        for row in 0..<rows {
//            for col in 0..<cols {
//                let x = col * tileWidth
//                let y = row * tileHeight
//                let width = (col == cols - 1) ? (w - x) : tileWidth
//                let height = (row == rows - 1) ? (h - y) : tileHeight
//                let rect = CGRect(x: x, y: y, width: width, height: height)
//                tiles.append(YDTile(rect: rect))
//            }
//        }
//
//        return YDImageAnalysis(tiles: tiles)
//    }
//}
//
//import UIKit
//import ImageIO
//import CoreGraphics
//
//public enum YDImageCompression {
//    /// 二分法压缩 CGImage，直到质量达到 targetSSIM 或迭代次数耗尽
//    /// - 参数 cgImage: 要压缩的 CGImage
//    /// - 参数 targetSSIM: 目标 SSIM 阈值，范围 0~1，越高质量越好
//    /// - 参数 maxIterations: 最大迭代次数，默认 8
//    /// - 返回值: 压缩后的 JPEG 数据
//    public static func compressCGImage(_ cgImage: CGImage, targetSSIM: Float, maxIterations: Int = 8) throws -> Data {
//        var lowQuality: CGFloat = 0.05
//        var highQuality: CGFloat = 1.0
//        var bestData: Data? = nil
//
//        for _ in 0..<maxIterations {
//            let midQuality = (lowQuality + highQuality) / 2
//            guard let data = YDImageUtils.jpegData(from: cgImage, quality: midQuality) else {
//                break
//            }
//
//            let ssim = YDSSIM.computeSSIM(referenceCG: cgImage, compressedData: data, sampleCount: 10)
//            if ssim >= targetSSIM {
//                bestData = data
//                lowQuality = midQuality
//            } else {
//                highQuality = midQuality
//            }
//
//            if abs(highQuality - lowQuality) < 0.01 {
//                break
//            }
//        }
//
//        if let result = bestData {
//            return result
//        }
//
//        // fallback: 直接用最高质量编码
//        if let fallbackData = YDImageUtils.jpegData(from: cgImage, quality: 1.0) {
//            return fallbackData
//        }
//
//        throw NSError(domain: "YDImageCompression", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法压缩图片"])
//    }
//}
//
//
//import UIKit
//import Accelerate
//import CoreGraphics
//
//public enum YDSSIM {
//    /// 计算参考图片和压缩图片的 SSIM
//    /// - 参数 referenceCG: 原图 CGImage
//    /// - 参数 compressedData: 压缩后的 JPEG 数据
//    /// - 参数 sampleCount: 采样块数量，默认 10
//    /// - 返回值: SSIM 值，0~1
//    public static func computeSSIM(referenceCG: CGImage, compressedData: Data, sampleCount: Int = 10) -> Float {
//        guard let compressedImage = UIImage(data: compressedData)?.cgImage else {
//            return 0.0
//        }
//
//        let w = min(referenceCG.width, compressedImage.width)
//        let h = min(referenceCG.height, compressedImage.height)
//        if w == 0 || h == 0 { return 0.0 }
//
//        var ssimSum: Float = 0
//        var count = 0
//
//        let stepX = max(1, w / (sampleCount + 1))
//        let stepY = max(1, h / (sampleCount + 1))
//
//        for y in stride(from: stepY / 2, to: h, by: stepY) {
//            for x in stride(from: stepX / 2, to: w, by: stepX) {
//                let patchW = min(32, w - x)
//                let patchH = min(32, h - y)
//                if patchW <= 0 || patchH <= 0 { continue }
//
//                guard
//                    let refPatch = YDImageUtils.extractGrayPatch(from: referenceCG, x: x, y: y, w: patchW, h: patchH),
//                    let cmpPatch = YDImageUtils.extractGrayPatch(from: compressedImage, x: x, y: y, w: patchW, h: patchH)
//                else {
//                    continue
//                }
//
//                ssimSum += ssimForPatches(refPatch, cmpPatch, w: patchW, h: patchH)
//                count += 1
//            }
//        }
//
//        return count > 0 ? ssimSum / Float(count) : 0.0
//    }
//
//    private static func ssimForPatches(_ a: [Float], _ b: [Float], w: Int, h: Int) -> Float {
//        let n = vDSP_Length(a.count)
//        var meanA: Float = 0
//        var meanB: Float = 0
//
//        vDSP_meanv(a, 1, &meanA, n)
//        vDSP_meanv(b, 1, &meanB, n)
//
//        var tmpA = [Float](repeating: 0, count: a.count)
//        var tmpB = [Float](repeating: 0, count: b.count)
//
//        var meanA_var = meanA
//        var meanB_var = meanB
//
//        tmpA.withUnsafeMutableBufferPointer { tmpAPtr in
//            a.withUnsafeBufferPointer { aPtr in
//                //  tmpA = a - meanA
//                vDSP_vsbm(
//                    aPtr.baseAddress!,
//                    1,
//                    &meanA_var,
//                    tmpAPtr.baseAddress!,
//                    1,
//                    tmpAPtr.baseAddress!,
//                    1,
//                    n
//                )
//            }
//        }
//
//        tmpB.withUnsafeMutableBufferPointer { tmpBPtr in
//            b.withUnsafeBufferPointer { bPtr in
//                // tmpB = b - meanB
//                vDSP_vsbm(
//                    bPtr.baseAddress!, 1,
//                    &meanB_var,
//                    tmpBPtr.baseAddress!, 1,
//                    tmpBPtr.baseAddress!, 1,
//                    n
//                )
//            }
//        }
//
//        var varA: Float = 0
//        var varB: Float = 0
//
//        tmpA.withUnsafeBufferPointer { tmpAPtr in
//            vDSP_measqv(tmpAPtr.baseAddress!, 1, &varA, n)
//        }
//
//        tmpB.withUnsafeBufferPointer { tmpBPtr in
//            vDSP_measqv(tmpBPtr.baseAddress!, 1, &varB, n)
//        }
//
//        var cov: Float = 0
//
//        tmpA.withUnsafeBufferPointer { tmpAPtr in
//            tmpB.withUnsafeBufferPointer { tmpBPtr in
//                vDSP_dotpr(tmpAPtr.baseAddress!, 1, tmpBPtr.baseAddress!, 1, &cov, n)
//            }
//        }
//
//        cov /= Float(a.count)
//
//        let c1: Float = (0.01 * 255) * (0.01 * 255)
//        let c2: Float = (0.03 * 255) * (0.03 * 255)
//
//        let numerator = (2 * meanA * meanB + c1) * (2 * cov + c2)
//        let denominator = (meanA * meanA + meanB * meanB + c1) * (varA + varB + c2)
//
//        if denominator == 0 { return 0 }
//        return max(0, min(1, numerator / denominator))
//    }
//}
