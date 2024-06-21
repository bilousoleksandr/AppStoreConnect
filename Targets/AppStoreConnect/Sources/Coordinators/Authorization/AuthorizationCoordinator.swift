//
//  AuthorizationCoordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Koval on 14.06.2024.
//

import Foundation
import AppKit
import AppStoreConnectKit
import AppStoreConnectUI

final class AuthorizationCoordinator: BaseCoordinator {
    private let serviceLocator: ServiceLocator
    private lazy var windowDelegate = WindowDelegate { [weak self] in
        self?.onFinish?()
    }
    
    private lazy var factory: AuthorizationFactory = AuthorizationFactory(
        serviceLocator: serviceLocator,
        finishAuthorization: { [weak self] in
            self?.window.close()
        }
    )

    private lazy var window: NSWindow = {
        let window = NSWindow()
        window.styleMask = [.titled, .miniaturizable, .closable]
        window.contentViewController = factory.makeAuthorizationViewController()
        window.delegate = windowDelegate
        window.isReleasedWhenClosed = false
        return window
    }()

    override var rootController: NSViewController? {
        window.contentViewController
    }

    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
    }

    override func start() {
        window.makeKeyAndOrderFront(nil)
        window.center()
    }
}
