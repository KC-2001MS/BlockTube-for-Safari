//
//  SafariWebExtensionHandler.swift
//  BlockTube macOS
//
//  Created by 茅根啓介 on 2023/02/10.
//------------------------------------------
//  GNU General Public License v3.0
//  © 2023 Free Software Foundation, Inc.
//  For more information on the use of the code, please refer to the license

import SafariServices
import os.log

let SFExtensionMessageKey = "message"

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

	func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)

        let response = NSExtensionItem()
        response.userInfo = [ SFExtensionMessageKey: [ "Response to": message ] ]

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
    
}
