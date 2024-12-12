//
//  PopoverViewModel.swift
//  ReaderMode
//
//  Created by Bartosz Kunat on 11/12/2024.
//

import SafariServices
import SwiftUI

@MainActor
final class PopoverViewModel: ObservableObject {
    @Published var webContent: WebPageContent?
    @Published var error: Error?
    @Published var isLoading = false

    private enum FetchError: LocalizedError {
        case noActivePage
        case invalidContent

        var errorDescription: String? {
            switch self {
            case .noActivePage: return "Could not access active page"
            case .invalidContent: return "Invalid content received"
            }
        }
    }

    func fetchWebContent() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let content = try await getCurrentPageContent()
            webContent = content
        } catch {
            self.error = error
        }
    }

    private func getCurrentPageContent() async throws -> WebPageContent? {
        let page = try await getActiveSafariPage()
        return try await requestAndReceiveContent(from: page)
    }

    private func getActiveSafariPage() async throws -> SFSafariPage {
        try await withCheckedThrowingContinuation { continuation in
            SFSafariApplication.getActiveWindow { window in
                guard let window else {
                    continuation.resume(throwing: FetchError.noActivePage)
                    return
                }

                window.getActiveTab { tab in
                    guard let tab else {
                        continuation.resume(throwing: FetchError.noActivePage)
                        return
                    }

                    tab.getActivePage { page in
                        if let page {
                            continuation.resume(returning: page)
                        } else {
                            continuation.resume(throwing: FetchError.noActivePage)
                        }
                    }
                }
            }
        }
    }

    private func requestAndReceiveContent(from page: SFSafariPage) async throws -> WebPageContent? {
        page.dispatchMessageToScript(
            withName: SafariExtensionMessage.Name.getContent.rawValue,
            userInfo: nil)

        for await notification in NotificationCenter.default
            .notifications(named: NSNotification.Name(SafariExtensionMessage.Notification.messageReceived.rawValue))
            .compactMap({ notification in
                if let userInfo = notification.userInfo,
                   let content = userInfo["content"] as? [String: String],
                   let title = content["title"],
                   let body = content["body"] {
                    return WebPageContent(title: title, body: body)
                } else {
                    return nil
                }
            }) {
            return notification
        }

        return nil
    }
}
