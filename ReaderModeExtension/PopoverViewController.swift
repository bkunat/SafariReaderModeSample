//
//  PopoverViewController.swift
//  ReaderMode
//
//  Created by Bartosz Kunat on 09/12/2024.
//


import SafariServices
import SwiftUI

final class PopoverViewController: SFSafariExtensionViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        let popover = Popover()
        self.view = NSHostingView(rootView: popover)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
