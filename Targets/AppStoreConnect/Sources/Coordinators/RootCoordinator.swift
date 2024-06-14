//
//  RootCoordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 14.06.2024.
//

import Foundation
import AppKit
import AppStoreConnectKit

final class RootCoordinator: BaseCoordinator {

    var onboardingFlowCompleted: Bool = false

    override func start() {
        startOnboarding()
    }

    private let serviceLocator: ServiceLocator

    init(serviceLocator: ServiceLocator) {
        self.serviceLocator = serviceLocator
        super.init()
    }
}

// MARK: - Flows

extension RootCoordinator {
    private func startAuthorization() {
        startOnboarding()
    }

    private func startOnboarding() {
        let childCoordinator = OnboardingCoordinator(serviceLocator: serviceLocator)
        self.addChild(childCoordinator)

        childCoordinator.onFinish = { [weak self, weak childCoordinator] in
            childCoordinator.map { self?.removeChild($0) }
            self?.startAuthorization()
        }

        childCoordinator.start()
    }
}
