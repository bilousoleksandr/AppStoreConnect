//
//  AuthView.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 21.05.2024.
//

import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                AuthInputField(title: "Issuer ID", binding: $viewModel.issuerID)
                AuthInputField(title: "Private Key ID", binding: $viewModel.privateKeyID)
                AuthInputField(title: "Private Key", binding: $viewModel.privateKey)
            }
            .padding()
            
            Button("Authorize") {
                Task {
                    try await viewModel.authorize()
                }
            }
            .disabled(!viewModel.canAuthorize)
        }
        .padding()
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
