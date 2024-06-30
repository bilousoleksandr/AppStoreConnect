//
//  RootCoordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 14.06.2024.
//

import Foundation
import AppKit
import AppStoreConnectKit
import LocalStorageAPI

final class RootCoordinator: BaseCoordinator {

    var onboardingFlowCompleted: Bool = false

    override func start() {
        
        let storage = serviceLocator.resolve(KeyValueStorageProtocol.self)
        
        let launchesCount = storage.integer(forKey: StorageKeys.launchCount)

        
        if (launchesCount < 2) {
            startOnboarding()
            storage.setValue(true, forKey: "isFirstlaunch")
        }
        else {
            startMain()
        }
        
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
    
    private func startMain() {
        let mainWindowCoordinator = MainWindowCoordinator(serviceLocator: serviceLocator, authorizationClosure: { [weak self] in
            self?.startAuthorization()
        })
        self.addChild(mainWindowCoordinator)
        
//        mainWindowCoordinator.onFinish = { [weak self, weak mainWindowCoordinator] in
//            onboardingCoordinator.map { self?.removeChild($0) }
//            self?.startAuthorization()
//            
//        }
        
        mainWindowCoordinator.start()
    }
}
