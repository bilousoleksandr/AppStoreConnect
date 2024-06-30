//
//  AuthView.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 21.05.2024.
//

import SwiftUI
import L10N
import DesignKit

public struct AuthView: View {
    @StateObject private var viewModel: AuthViewModel
    
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
                viewModel.isImportingPrivateKey = true
            }
            .fileImporter(isPresented: $viewModel.isImportingPrivateKey,
                          allowedContentTypes: viewModel.allowedContentTypes,
                          onCompletion: viewModel.onImprotingPrivateKeyFileURL)
            
            AsyncButton(disabled: !viewModel.canAuthorize) {
                await viewModel.authorize()
            } label: {
                Text(L10NStrings.Authorization.Button.authorize)
            }            
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
