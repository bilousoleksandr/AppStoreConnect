//
//  OnboardingCoordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import Foundation
import AppKit
import AppStoreConnectUI
import SwiftUI

final class OnblardingImpl: Onboarding {
    
}

final class OnboardingCoordinator: BaseCoordinator {
    override func start() {
        let onboardingViewModel = OnboardingViewModel(onboarding: OnblardingImpl())
        let onboardingView = OnboardingView(viewModel: onboardingViewModel)
        
        let viewController = NSHostingController(rootView: onboardingView)
        
        rootNavigationController.addChild(viewController)
        rootNavigationController.view.addSubview(viewController.view)

        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: rootNavigationController.view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: rootNavigationController.view.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: rootNavigationController.view.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: rootNavigationController.view.trailingAnchor)
        ])
    }
}
