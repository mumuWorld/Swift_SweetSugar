//
//  TestTool.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/4/10.
//  Copyright © 2025 Mumu. All rights reserved.
//

import Foundation
import AVFoundation

class TestTool {
    
    /// 提取图片的主色
    func dominantColor(from image: UIImage) -> UIColor? {
        guard image.cgImage != nil else { return nil }
        
        // Resize to small size for performance
        let thumbSize = CGSize(width: 50, height: 50)
        
        UIGraphicsBeginImageContext(thumbSize)
        image.draw(in: CGRect(origin: .zero, size: thumbSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let resizedCGImage = resizedImage?.cgImage,
              let data = resizedCGImage.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data) else {
            return nil
        }
        
        let bytesPerPixel = 4
        let width = resizedCGImage.width
        let height = resizedCGImage.height
        
        let colorCounter = NSCountedSet(capacity: width * height)
        
        for x in 0..<width {
            for y in 0..<height {
                let offset = (y * width + x) * bytesPerPixel
                let r = ptr[offset]
                let g = ptr[offset + 1]
                let b = ptr[offset + 2]
                let a = ptr[offset + 3]
                
                // 忽略透明像素
                if a > 0 {
                    let color = UIColor(red: CGFloat(r) / 255.0,
                                        green: CGFloat(g) / 255.0,
                                        blue: CGFloat(b) / 255.0,
                                        alpha: 1.0)
                    colorCounter.add(color)
                }
            }
        }
        
        // 取出现次数最多的颜色
        let sortedColors = colorCounter.allObjects.sorted {
            colorCounter.count(for: $0) > colorCounter.count(for: $1)
        }
        
        return sortedColors.first as? UIColor
    }
    
    /// 提取视频首帧图片的
    func getFirstFrameAsync(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let time = CMTime(seconds: 0.0, preferredTimescale: 600)

        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, _, error in
            if let cgImage = cgImage {
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("❌ Failed to generate image: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    /// 提取视频首帧图片的 主颜色
    func testImg(complete: @escaping (UIImage?, UIColor?) -> Void) {
        if let url = Bundle.main.url(forResource: "RPReplay", withExtension: "MP4") {
            getFirstFrameAsync(from: url) { img in
                guard let img else { return }
                let color = self.dominantColor(from: img)
                complete(img, color)
            }
        }
    }
}

