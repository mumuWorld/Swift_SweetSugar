//
//  ActionViewController.swift
//  MMActionExtension
//
//  Created by 杨杰 on 2025/4/29.
//  Copyright © 2025 Mumu. All rights reserved.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        var imageFound = false
        
        let docxType = UTType(filenameExtension: "docx") // 或者手动指定 identifier
        let docxID = docxType?.identifier ?? "org.openxmlformats.wordprocessingml.document"
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    provider.loadItem(forTypeIdentifier: UTType.image.identifier) { (imageURL, error) in
                        if let imageURL = imageURL as? URL {
                            // ✅ 在这里你可以读取或复制文件
                            print("✅ Received file at URL: \(imageURL)")
                            Task { @MainActor in
                                if let strongImageView = weakImageView {
                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
                                }
                            }
                        }
                    }
                    
                    imageFound = true
                    break
                } else if provider.hasItemConformingToTypeIdentifier(docxID) {
                    
                    provider.loadItem(forTypeIdentifier: docxID, options: nil) { (item, error) in
                        if let url = item as? URL {
                            self.handlePDF(at: url)
//                            self.openContainerApp()
                        }
                    }
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    func handlePDF(at url: URL) {
        if let url = URL(string: "ydtranslator://router/account") {
            Task {
                extensionContext?.open(url, completionHandler: { success in
                    if success {
                        print("已成功打开主 App")
                    } else {
                        print("打开主 App 失败")
                    }
                })
            }
        }
    }
    
    private func openContainerApp() {
        
        let scheme = "ydtranslator://"
        
        let url: URL = URL(string: scheme)!
        
        let context = NSExtensionContext()
        
        context.open(url, completionHandler: nil)
        
        var responder = self as UIResponder?
        
        let selectorOpenURL = sel_registerName("openURL:")
        
        while (responder != nil) {
            
            if responder!.responds(to: selectorOpenURL) {
                
                responder!.perform(selectorOpenURL, with: url)
                
                break
                
            }
            responder = responder?.next
            
        }
        
    }


    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
