//
//  SafariWebExtensionHandler.swift
//  SafariTranslate
//
//  Created by 杨杰 on 2021/12/9.
//  Copyright © 2021 Mumu. All rights reserved.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem

        if #available(iOSApplicationExtension 15.0, *) {
            let message = item.userInfo?[SFExtensionMessageKey]
            os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
            let response = NSExtensionItem()
            response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]
            context.completeRequest(returningItems: [response], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
        
    }

}
