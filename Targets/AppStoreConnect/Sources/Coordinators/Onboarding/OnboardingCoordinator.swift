//
//  OnboardingCoordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 14.06.2024.
//

import Foundation
import AppKit
import AppStoreConnectKit

protocol OnboardingRoutable: AnyObject {
    func finishOnboarding()
}

final class OnboardingCoordinator: BaseCoordinator {
    private let serviceLocator: ServiceLocator
    private lazy var windowDelegate = WindowDelegate { [weak self] in
        self?.onFinish?()
    }
    private lazy var factory: OnboardingFactory = OnboardingFactory(
        serviceLocator: serviceLocator,
        finishOnboarding: { [weak self] in
            self?.window.close()
        }
    )

    private lazy var window: NSWindow = {
        let window = NSWindow()
        window.styleMask = [.titled, .miniaturizable, .closable]
        window.contentViewController = factory.makeOnboardingViewController()
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
