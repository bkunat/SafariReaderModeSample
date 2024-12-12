//
//  SafariExtensionHandler.swift
//  ReaderModeExtension
//
//  Created by Bartosz Kunat on 02/12/2024.
//

import SafariServices

final class SafariExtensionHandler: SFSafariExtensionHandler {
    override func popoverViewController() -> SFSafariExtensionViewController {
        PopoverViewController()
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        window.getActiveTab { (tab) in
            tab?.getActivePage(completionHandler: { (page) in
                page?.getPropertiesWithCompletionHandler( { (properties) in
                    validationHandler(properties?.url != nil, "")
                })
            })
        }
    }

    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        guard let message = SafariExtensionMessage.Name(rawValue: messageName) else { return }
        
        switch message {
        case .pageContent:
            NotificationCenter.default.post(
                name: NSNotification.Name(SafariExtensionMessage.Notification.messageReceived.rawValue),
                object: nil,
                userInfo: userInfo
            )
        case .getContent:
            break // Handle if needed
        }
    }
}
