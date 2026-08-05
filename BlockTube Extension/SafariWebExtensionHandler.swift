//
//  SafariWebExtensionHandler.swift
//  BlockTube macOS
//
//  Created by 茅根啓介 on 2023/02/10.
//------------------------------------------
//  Copyright © 2026 Keisuke Chinone
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License v3.0.
//  This program is distributed WITHOUT ANY WARRANTY.
//  See <https://www.gnu.org/licenses/gpl-3.0.html> for details.

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
