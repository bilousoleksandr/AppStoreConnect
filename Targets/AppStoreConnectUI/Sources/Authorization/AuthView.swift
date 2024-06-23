//
//  AuthView.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 21.05.2024.
//

import SwiftUI
import UniformTypeIdentifiers
import L10N

public struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel
    @State private var isImporting: Bool = false
    
    public init(viewModel: AuthViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                AuthInputField(title: L10NStrings.Authorization.TextField.issuerId, binding: $viewModel.issuerID)
            }
            .padding()
            
            Button(L10NStrings.Authorization.Button.privateKey) {
                isImporting = true
            }
            .fileImporter(isPresented: $isImporting,
                          allowedContentTypes: [UTType(filenameExtension: "p8")!],
                          onCompletion: { result in
                
                switch result {
                case .success(let url):
                    viewModel.privateKeyFileURL = url
                case .failure(let error):
                    print("AuthView failed to pick  Private Key File with error: \(error)")
                }
                
                isImporting = false
            })
            
            Button("Authorize") {
                Task {
                    await viewModel.authorize()
                }
            }
            .disabled(!viewModel.canAuthorize)
        }
        .padding()
        .frame(width: 680, height: 400)
    }
}

struct AuthInputField: View {
    private let title: String
    private var binding: Binding<String>
    
    init(title: String, binding: Binding<String>) {
        self.title = title
        self.binding = binding
    }
    
    var body: some View {
        HStack {
            Text(title)
            TextField("", text: binding)
        }
    }
}
