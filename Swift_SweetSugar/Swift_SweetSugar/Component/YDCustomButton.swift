//
//  YDCustomButton.swift
//
//

import UIKit
import SnapKit

open class YDCustomButton: UIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.addSubview(_titleLabel)
        contentView.addSubview(_imageView)
        adjustsImageWhenHighlighted = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// icon 和 title 的父视图
    lazy var contentView: UIView = {
        let item = UIView()
        item.backgroundColor = .clear
        item.isUserInteractionEnabled = false
        return item
    }()
    
    /// 按钮配置类
    open lazy var configure: YDCustomButtonConfigure = YDCustomButtonConfigure()

    public lazy var _titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()
    
    public lazy var _imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFill
        imgV.isUserInteractionEnabled = false
        return imgV
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        //约束子控件的宽高
        updateContentView()
    }
}

// MARK: - Public
public extension YDCustomButton {
    
    /// 算上内边距size
    func fitSizeWithInsets(_ state: Int = 0) -> CGSize {
        let size = fitSizeContent(state)
        return CGSize(width: size.width + configure.edgeInsets.left + configure.edgeInsets.right,
                      height: size.height + configure.edgeInsets.top + configure.edgeInsets.bottom)
    }
    
    /// 返回按钮合适的size  0 正常状态 1选中状态
    func fitSizeContent(_ state: Int = 0) -> CGSize {
        var fitTitleSize: CGSize = .zero
        
        if state == 0 {
            fitTitleSize = configure.title.boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: configure.font as Any], context: nil).size
        } else if state == 1 {
            fitTitleSize = configure.selectedTitle.boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: configure.selectedFont as Any], context: nil).size
        }
        fitTitleSize = CGSize(ceil(fitTitleSize.width), ceil(fitTitleSize.height))
        
        switch configure.imagePosition {
        case .right, .left:
            return CGSize(configure.imageSize.width + configure.spacing + fitTitleSize.width, max(configure.imageSize.height, fitTitleSize.height))
        case .bottom, .top:
            let h = configure.imageSize.height + configure.spacing + fitTitleSize.height
            return CGSize(max(configure.imageSize.width, fitTitleSize.width), h)
        }
    }
    
    func setConfigure(con: YDCustomButtonConfigure) {
        configure = con
        //配置背景颜色
        updateBgImgView()
        //根据选中状态赋值
        isYDSelected = isSelected
        
        let imgSize = configure.imageSize.equalTo(.zero) ? (configure.image?.size ?? .zero) : configure.imageSize
        //这里是防止没有传图片大小
        configure.imageSize = imgSize
        //布局
        switch configure.imagePosition {
        case .left:
            _titleLabel.textAlignment = .left
            _titleLabel.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.bottom.lessThanOrEqualToSuperview()
                make.top.greaterThanOrEqualToSuperview()
                make.left.equalToSuperview().offset(imgSize.width + configure.spacing)
            }
            _imageView.snp.remakeConstraints { (make) in
                make.size.equalTo(imgSize)
                make.centerY.left.equalToSuperview()
            }
        case .right:
            _imageView.snp.remakeConstraints { (make) in
                make.size.equalTo(imgSize)
                make.right.centerY.equalToSuperview()
            }
            _titleLabel.textAlignment = .right
            _titleLabel.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview()
                make.left.bottom.lessThanOrEqualToSuperview()
                make.right.equalToSuperview().offset(-imgSize.width - configure.spacing)
            }
        case .bottom:
            _imageView.snp.remakeConstraints { (make) in
                make.size.equalTo(imgSize)
                make.centerX.bottom.equalToSuperview()
            }
            _titleLabel.textAlignment = .center
            _titleLabel.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.top.greaterThanOrEqualToSuperview()
                make.bottom.equalToSuperview().offset(-imgSize.height - configure.spacing)
            }
        case .top:
            _imageView.snp.remakeConstraints { (make) in
                make.size.equalTo(imgSize)
                make.top.centerX.equalToSuperview()
            }
            _titleLabel.textAlignment = .center
            _titleLabel.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(imgSize.height + configure.spacing)
                make.left.right.equalToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
            }
        }
    }
    
    var isYDSelected: Bool {
        set {
            isSelected = newValue
            if isSelected {
                _titleLabel.text = configure.selectedTitle
                _titleLabel.textColor = configure.titleSelectedColor
                updateIconImgView(img: configure.selectedImage)
                updateFont(font: configure.selectedFont)
            } else {
                _titleLabel.text = configure.title
                _titleLabel.textColor = configure.titleColor
                updateIconImgView(img: configure.image)
                updateFont(font: configure.font)
            }
            layoutIfNeeded()
        }
        get { return isSelected }
    }
    
}

extension YDCustomButton {
    
    /// 更新背景图片
    func updateBgImgView() {
        setBackgroundImage(configure.backgroundImg, for: .normal)
        if let selBgImg = configure.backgroundSelImg {
            setBackgroundImage(selBgImg, for: .selected)
        } else {
            setBackgroundImage(configure.backgroundImg, for: .selected)
        }
    }
    
    /// 更新icon_image
    func updateIconImgView(img: UIImage?) {
        if let t_img = img {
            _imageView.isHidden = false
            _imageView.image = t_img
        } else {
            _imageView.isHidden = true
            _imageView.image = nil
        }
    }
    
    func updateFont(font: UIFont?) {
        if let t_font = font {
            _titleLabel.font = t_font
        }
    }
    
    func updateContentView() {
        var fitSize = fitSizeContent(isSelected ? 1 : 0)
        if !mm_size.equalTo(.zero) {
            fitSize = CGSize(min(mm_width, fitSize.width), min(mm_height, fitSize.height))
        }
        contentView.snp.remakeConstraints { make in
            make.size.equalTo(fitSize)
            if configure.alignment.contains(.center_x) {
                make.centerX.equalToSuperview().offset(configure.edgeInsets.left)
            }
            if configure.alignment.contains(.center_y) {
                make.centerY.equalToSuperview().offset(configure.edgeInsets.top)
            }
            if configure.alignment.contains(.left) {
                make.leading.equalToSuperview().offset(configure.edgeInsets.left)
            } else if configure.alignment.contains(.right) {
                make.trailing.equalToSuperview().offset(configure.edgeInsets.right)
            }
            if configure.alignment.contains(.top) {
                make.top.equalToSuperview().offset(configure.edgeInsets.top)
            } else if configure.alignment.contains(.bottom) {
                make.bottom.equalToSuperview().offset(configure.edgeInsets.bottom)
            }
        }
    }
}

// MARK: - 配置类
/// 按钮配置类 后续可配置高亮
public struct YDCustomButtonConfigure {
    
    public enum YDCustomButtonImagePosition {
        case left, right, top, bottom
    }

    /// 图片位置
    public var imagePosition: YDCustomButtonImagePosition = .left
    
    public var spacing: CGFloat = 0
    
    /// 设置正常文字和选中文案一致
    public var title: String = "" {
        didSet {
            selectedTitle = title
        }
    }
    public var selectedTitle: String = ""
    /// 文本颜色
    public var titleColor: UIColor = .black
    public var titleSelectedColor: UIColor = .black
    
    public var image: UIImage? {
        didSet {
            guard let img = image else { return }
            if selectedImage == nil {
                selectedImage = img
            }
        }
    }
    public var selectedImage: UIImage?
    
    /// 设置图片大小,不然取图片本身大小
    public var imageSize: CGSize = CGSize.zero
    
    /// 背景图片
    public var backgroundImg: UIImage? {
        didSet { backgroundSelImg = backgroundImg }
    }
    public var backgroundSelImg: UIImage?
    
    public var font: UIFont? = UIFont.systemFont(ofSize: 17)
    private var _selectedFont: UIFont?
    public var selectedFont: UIFont? {
        get { return _selectedFont == nil ? font : _selectedFont }
        set { _selectedFont = newValue }
    }
    
    /// 外边框 优先布局图片: 图片在左 则 先使用左边距
    public var edgeInsets: UIEdgeInsets = .zero
    /// 居中时也会根据 insets 的左 上 设置偏移量
    public var alignment: ContentAlignment = [.center_x, .center_y]
    
    /// 内容的对齐方式
    public struct ContentAlignment: OptionSet {
        
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        /// 水平居中
        public static let center_x = ContentAlignment(rawValue: 1)
        /// 垂直居中
        public static let center_y = ContentAlignment(rawValue: 2)
        public static let left = ContentAlignment(rawValue: 4)
        public static let right = ContentAlignment(rawValue: 8)
        public static let top = ContentAlignment(rawValue: 16)
        public static let bottom = ContentAlignment(rawValue: 32)
    }
}
