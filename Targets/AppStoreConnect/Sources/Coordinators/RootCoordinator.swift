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
        let authorizationCoordinator = AuthorizationCoordinator(serviceLocator: serviceLocator)
        
        self.addChild(authorizationCoordinator)

        authorizationCoordinator.onFinish = { [weak self, weak authorizationCoordinator] in
            authorizationCoordinator.map { self?.removeChild($0) }
        }

        authorizationCoordinator.start()
    }

    private func startOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(serviceLocator: serviceLocator)
        self.addChild(onboardingCoordinator)

        onboardingCoordinator.onFinish = { [weak self, weak onboardingCoordinator] in
            onboardingCoordinator.map { self?.removeChild($0) }
            self?.startAuthorization()
        }

        onboardingCoordinator.start()
    }
}
