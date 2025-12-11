//
//  MMUILabelTestVC.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/10/23.
//  Copyright © 2025 Mumu. All rights reserved.
//

import UIKit

class MMUILabelTestVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        labelHeight()
         
        // 最准确的 3 行文本高度约束设置方法
        setupMostAccurateThreeLineLabel()
    }
    
    func labelHeight() {
        let label = UILabel()
        label.text = "测试两行\n测试两行"
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .systemBlue
        label.numberOfLines = 2
        label.sizeToFit()
        
        print("=== UILabel 行高计算方法对比 ===")
        
        // 方法1: font.lineHeight * 行数
        let method1Height = label.font.lineHeight * 2
        print("方法1 - font.lineHeight * 2 =", method1Height)
        
        // 方法2: intrinsicContentSize
        let method2Height = label.intrinsicContentSize.height
        print("方法2 - intrinsicContentSize.height =", method2Height)
        
        // 方法3: 改进的精确计算方法
        let method3Height = preciseLabelHeight(for: label.text ?? "", font: label.font, width: CGFloat.greatestFiniteMagnitude, lines: 2)
        print("方法3 - preciseLabelHeight =", method3Height)
        
        // 方法4: 使用 boundingRect 直接计算
        let method4Height = calculateLabelHeightWithBoundingRect(text: label.text ?? "", font: label.font, width: CGFloat.greatestFiniteMagnitude, maxLines: 2)
        print("方法4 - boundingRect 直接计算 =", method4Height)
        
        // 方法5: 使用 sizeThatFits
        let method5Height = calculateLabelHeightWithSizeThatFits(text: label.text ?? "", font: label.font, width: CGFloat.greatestFiniteMagnitude, maxLines: 2)
        print("方法5 - sizeThatFits 计算 =", method5Height)
        
        // 方法6: 考虑行间距的精确计算
        let method6Height = calculateLabelHeightWithLineSpacing(text: label.text ?? "", font: label.font, width: CGFloat.greatestFiniteMagnitude, maxLines: 2, lineSpacing: 0)
        print("方法6 - 考虑行间距计算 =", method6Height)
        
        print("=== 实际 Label 尺寸 ===")
        print("label.frame.size =", label.frame.size)
        
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(8)
        }
        
        // 添加测试不同宽度约束的情况
        testLabelWithWidthConstraint()
    }
    
    func preciseLabelHeight(for text: String,
                            font: UIFont,
                            width: CGFloat,
                            lines: Int) -> CGFloat {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping

        let attrText = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .paragraphStyle: paragraph
            ]
        )

        // 用 TextKit/CoreText 实际排版
        let rect = attrText.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        // 限制为最大行数
        let singleLineHeight = attrText.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        ).height

        let maxHeight = singleLineHeight * CGFloat(lines)
        return min(rect.height, maxHeight)
    }
    
    // MARK: - 新增的 UILabel 行高计算方法
    
    /// 方法4: 使用 boundingRect 直接计算
    func calculateLabelHeightWithBoundingRect(text: String, font: UIFont, width: CGFloat, maxLines: Int) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        let boundingRect = text.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes,
            context: nil
        )
        
        // 限制最大行数
        let singleLineHeight = font.lineHeight
        let maxHeight = singleLineHeight * CGFloat(maxLines)
        
        return min(ceil(boundingRect.height), maxHeight)
    }
    
    /// 方法5: 使用 sizeThatFits 计算
    func calculateLabelHeightWithSizeThatFits(text: String, font: UIFont, width: CGFloat, maxLines: Int) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = font
        label.numberOfLines = maxLines
        label.lineBreakMode = .byWordWrapping
        
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        return size.height
    }
    
    /// 方法6: 考虑行间距的精确计算
    func calculateLabelHeightWithLineSpacing(text: String, font: UIFont, width: CGFloat, maxLines: Int, lineSpacing: CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        let boundingRect = attributedText.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        // 计算单行高度（包含行间距）
        let singleLineHeight = font.lineHeight + lineSpacing
        let maxHeight = singleLineHeight * CGFloat(maxLines) - lineSpacing // 最后一行不需要行间距
        
        return min(ceil(boundingRect.height), maxHeight)
    }
    
    /// 测试不同宽度约束下的行高计算
    func testLabelWithWidthConstraint() {
        print("\n=== 测试不同宽度约束下的行高 ===")
        
        let longText = "这是一段很长的文本，用来测试在不同宽度约束下UILabel的行高计算是否准确。当文本超过一行时，需要换行显示，这时候行高的计算就变得更加重要了。"
        let font = UIFont.systemFont(ofSize: 16)
        let widths: [CGFloat] = [100, 200, 300]
        
        for width in widths {
            print("\n--- 宽度约束: \(width) ---")
            
            let method1 = calculateLabelHeightWithBoundingRect(text: longText, font: font, width: width, maxLines: 0)
            print("boundingRect 计算: \(method1)")
            
            let method2 = calculateLabelHeightWithSizeThatFits(text: longText, font: font, width: width, maxLines: 0)
            print("sizeThatFits 计算: \(method2)")
            
            let method3 = calculateLabelHeightWithLineSpacing(text: longText, font: font, width: width, maxLines: 0, lineSpacing: 2)
            print("考虑行间距计算: \(method3)")
            
            // 实际创建 Label 验证
            let testLabel = UILabel()
            testLabel.text = longText
            testLabel.font = font
            testLabel.numberOfLines = 0
            testLabel.lineBreakMode = .byWordWrapping
            let actualSize = testLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
            print("实际 Label 高度: \(actualSize.height)")
        }
    }
    
    /// 最推荐的 UILabel 行高计算方法
    /// - Parameters:
    ///   - text: 文本内容
    ///   - font: 字体
    ///   - width: 宽度约束
    ///   - maxLines: 最大行数，0表示不限制
    ///   - lineSpacing: 行间距，默认为0
    /// - Returns: 计算出的高度
    func recommendedLabelHeight(text: String, font: UIFont, width: CGFloat, maxLines: Int = 0, lineSpacing: CGFloat = 0) -> CGFloat {
        // 创建段落样式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = lineSpacing
        
        // 创建属性字符串
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        // 计算边界矩形
        let boundingRect = attributedText.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        var calculatedHeight = ceil(boundingRect.height)
        
        // 如果设置了最大行数限制
        if maxLines > 0 {
            let singleLineHeight = font.lineHeight + lineSpacing
            let maxHeight = singleLineHeight * CGFloat(maxLines) - lineSpacing
            calculatedHeight = min(calculatedHeight, maxHeight)
        }
        
        return calculatedHeight
     }
     
     
     // MARK: - 最准确的 UILabel 3 行文本高度约束设置方法
     
     /// 最准确的 3 行文本高度约束设置方法
     func setupMostAccurateThreeLineLabel() {
         print("\n=== 最准确的 3 行文本高度约束设置方法 ===")
         
         let longText = "这是一段很长的文本内容，用来测试当 UILabel 限制为最多 3 行时的精确高度计算。当文本内容超过 3 行时，应该被截断显示，并且高度应该固定为 3 行的精确高度。"
         let font = UIFont.systemFont(ofSize: 16)
         let width: CGFloat = 300
         
         let label = UILabel()
         label.text = longText
         label.font = font
         label.numberOfLines = 3
         label.lineBreakMode = .byTruncatingTail
         label.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
         
         // 最准确的高度计算方法（无限制）
         let actualHeight = calculateEfficientHeight(text: longText, font: font, width: width)
         print("文本实际需要的高度: \(actualHeight)")
         
         // 限制为 3 行的高度
         let constrainedHeight = calculateHeightWithMaxLines(text: longText, font: font, width: width, maxLines: 3)
         print("限制 3 行后的高度: \(constrainedHeight)")
         
         view.addSubview(label)
         label.snp.makeConstraints { make in
             make.top.equalToSuperview().offset(150)
             make.leading.equalToSuperview().offset(20)
             make.width.equalTo(width)
             make.height.equalTo(constrainedHeight) // 使用限制行数后的高度
         }
         
         // 验证准确性
         DispatchQueue.main.async {
             print("Label 实际 frame 高度: \(label.frame.height)")
             print("Label intrinsicContentSize 高度: \(label.intrinsicContentSize.height)")
         }
     }
     
     /// 最准确的 UILabel 高度计算方法（无限制）
     /// - Parameters:
     ///   - text: 文本内容
     ///   - font: 字体
     ///   - width: 宽度约束
     /// - Returns: 文本实际需要的高度值
     func calculateMostAccurateHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
         // 使用 NSAttributedString 的 boundingRect 方法，获取文本实际需要的高度
         let attributedString = NSAttributedString(string: text, attributes: [
             .font: font
         ])
         
         let boundingRect = attributedString.boundingRect(
             with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
             options: [.usesLineFragmentOrigin, .usesFontLeading],
             context: nil
         )
         
         print("📏 NSAttributedString boundingRect 原始高度: \(boundingRect.height)")
         
         // 返回实际高度，向上取整确保像素对齐
         let finalHeight = ceil(boundingRect.height)
         print("📏 取整后高度: \(finalHeight)")
         
         return finalHeight
     }
     
     /// 高效的文本高度计算方法（无限制）
     /// - Parameters:
     ///   - text: 文本内容
     ///   - font: 字体
     ///   - width: 宽度约束
     /// - Returns: 文本实际需要的高度值
     func calculateEfficientHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
         // 直接使用 NSString 的方法，避免创建 NSAttributedString
         let boundingRect = (text as NSString).boundingRect(
             with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
             options: [.usesLineFragmentOrigin, .usesFontLeading],
             attributes: [.font: font],
             context: nil
         )
         
         print("⚡️ NSString boundingRect 原始高度: \(boundingRect.height)")
         
         // 返回实际高度，向上取整确保像素对齐
         let finalHeight = ceil(boundingRect.height)
         print("⚡️ 取整后高度: \(finalHeight)")
         
         return finalHeight
     }
     
     /// 限制最大行数的高度计算方法
     /// - Parameters:
     ///   - text: 文本内容
     ///   - font: 字体
     ///   - width: 宽度约束
     ///   - maxLines: 最大行数
     /// - Returns: 限制行数后的高度值
     func calculateHeightWithMaxLines(text: String, font: UIFont, width: CGFloat, maxLines: Int) -> CGFloat {
         let actualHeight = calculateEfficientHeight(text: text, font: font, width: width)
         let maxAllowedHeight = font.lineHeight * CGFloat(maxLines)
         
         print("🔢 单行高度: \(font.lineHeight)")
         print("🔢 最大允许高度 (\(maxLines) 行): \(maxAllowedHeight)")
         print("🔢 实际计算高度: \(actualHeight)")
         
         let finalHeight = min(actualHeight, maxAllowedHeight)
         print("🔢 最终限制后高度: \(finalHeight)")
         
         return finalHeight
     }
 }
 
 // MARK: - 自定义 UILabel 类，重写 intrinsicContentSize
 class ThreeLineLabel: UILabel {
     var maxHeight: CGFloat = 0
     
     override var intrinsicContentSize: CGSize {
         let originalSize = super.intrinsicContentSize
         let limitedHeight = min(originalSize.height, maxHeight)
         return CGSize(width: originalSize.width, height: limitedHeight)
     }
     
     override func invalidateIntrinsicContentSize() {
         super.invalidateIntrinsicContentSize()
     }
 }
