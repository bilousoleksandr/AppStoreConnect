//
//  MainWindowCoordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Koval on 30.06.2024.
//  Copyright © 2024 com.bilous. All rights reserved.
//

import Foundation
import AppKit
import AppStoreConnectKit
import AppStoreConnectUI

final class MainWindowCoordinator: BaseCoordinator {
    private let serviceLocator: ServiceLocator
    private lazy var windowDelegate = WindowDelegate { [weak self] in
        self?.onFinish?()
    }
    
    private let authorizationClosure: () -> Void
    
    private lazy var factory: MainWindowFactory = MainWindowFactory(
        serviceLocator: serviceLocator,
        finish: { [weak self] in
            self?.window.close()
        }) { [weak self] in
            self?.authorizationClosure()
        }

    private lazy var window: NSWindow = {
        let window = NSWindow()
        window.styleMask = [.titled, .miniaturizable, .closable]
        window.contentViewController = factory.makeMainWindowViewController()
        window.delegate = windowDelegate
        window.isReleasedWhenClosed = false
        return window
    }()

    override var rootController: NSViewController? {
        window.contentViewController
    }
    
    init(serviceLocator: ServiceLocator,
         authorizationClosure: @escaping () -> Void)
    {
        self.serviceLocator = serviceLocator
        self.authorizationClosure = authorizationClosure
    }

    override func start() {
        window.makeKeyAndOrderFront(nil)
        window.center()
    }
}
