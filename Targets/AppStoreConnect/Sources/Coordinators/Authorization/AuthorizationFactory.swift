//
//  AuthorizationFactory.swift
//  AppStoreConnect
//
//  Created by Oleksandr Koval on 14.06.2024.
//

import Foundation
import AppKit
import AppStoreConnectUI
import SwiftUI
import AppStoreConnectKit
import AppStoreConnectAuth

extension AuthorizationService: Authorization {
    
}

final class AuthorizationFactory {
    private let serviceLocator: ServiceLocator
    private let finishAuthorization: () -> Void

    init(
        serviceLocator: ServiceLocator,
        finishAuthorization: @escaping () -> Void
    ) {
        self.serviceLocator = serviceLocator
        self.finishAuthorization = finishAuthorization
    }

    func makeAuthorizationViewController() -> NSViewController {
        let authViewModel = AuthViewModel(authorization: AuthorizationService())
        let authView = AuthView(viewModel: authViewModel)
        return NSHostingController(rootView: authView)
    }
}
