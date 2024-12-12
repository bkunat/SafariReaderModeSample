//
//  SafariExtensionMessage.swift
//  ReaderMode
//
//  Created by Bartosz Kunat on 12/12/2024.
//

enum SafariExtensionMessage {
    enum Name: String {
        case pageContent = "pageContent"
        case getContent = "getContent"
    }
    
    enum Notification: String {
        case messageReceived = "messageReceived"
    }
}
