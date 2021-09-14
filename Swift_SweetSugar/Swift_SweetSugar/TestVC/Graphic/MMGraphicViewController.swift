//
//  MMGraphicViewController.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2021/9/3.
//  Copyright © 2021 Mumu. All rights reserved.
//

import UIKit

class MMGraphicViewController: UIViewController {
    
    @IBOutlet weak var imageV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        create()
    }

}

extension MMGraphicViewController {
    func create() -> Void {
        let firstImg = UIImage(named: "graphic")
        let size = UIScreen.main.bounds.size
        let containerSize = CGSize(width: size.width + 16, height: size.height + 8 + 99)
        UIGraphicsBeginImageContextWithOptions(containerSize, true, UIScreen.main.scale)
        UIColor.red.setFill()
        let context = UIGraphicsGetCurrentContext()
        context?.fill(CGRect(origin: .zero, size: containerSize))
        firstImg?.draw(in: CGRect(x: 8, y: 8, width: size.width, height: size.height))
        let iconImg = UIImage(named: "ic_mark_ocr")
        iconImg?.draw(in: CGRect(x: 8, y: size.height + 8 + 25, width: 177, height: 48))
        let qrImg = UIImage(named: "ic_mark_qr_ocr")
        qrImg?.draw(in: CGRect(x: containerSize.width - 75, y: size.height + 8 + 14, width: 60, height: 77))
        
        let finalImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageV.image = finalImg
        
        let compressImg = finalImg!.jpegData(compressionQuality: 0.3)
        
        UIImageWriteToSavedPhotosAlbum(finalImg!, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error :NSError, contextInfo: Any) {
//            mm_printLog(error)
    }
}
