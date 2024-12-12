//
//  WebPageContent.swift
//  ReaderMode
//
//  Created by Bartosz Kunat on 09/12/2024.
//

import SwiftUI
import SafariServices

struct Popover: View {
    @StateObject private var viewModel = PopoverViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Page Content")
                .font(.headline)
            
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                VStack(spacing: 12) {
                    Text(error.localizedDescription)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    
                    Button("Retry") {
                        Task {
                            await viewModel.fetchWebContent()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else if let content = viewModel.webContent {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(content.title)
                            .font(.title2)
                            .bold()
                        
                        Text(content.body)
                            .textSelection(.enabled)
                    }
                }
            }
        }
        .frame(minWidth: 300, minHeight: 400)
        .padding()
        .task {
            await viewModel.fetchWebContent()
        }
    }
}
