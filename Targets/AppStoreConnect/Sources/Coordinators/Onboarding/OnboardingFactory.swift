//
//  OnboardingFactory.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 14.06.2024.
//

import Foundation
import AppKit
import AppStoreConnectUI
import SwiftUI
import AppStoreConnectKit

final class OnblardingImpl: Onboarding {

}

final class OnboardingFactory {
    private let serviceLocator: ServiceLocator
    private let finishOnboarding: () -> Void

    init(
        serviceLocator: ServiceLocator,
        finishOnboarding: @escaping () -> Void
    ) {
        self.serviceLocator = serviceLocator
        self.finishOnboarding = finishOnboarding
    }

    func makeOnboardingViewController() -> NSViewController {
        let onboardingViewModel = OnboardingViewModel(
            onboarding: OnblardingImpl(),
            userDefaults: serviceLocator.resolve(),
            finishOnboarding: finishOnboarding

        )
        let onboardingView = OnboardingView(viewModel: onboardingViewModel)
        return NSHostingController(rootView: onboardingView)
    }
}
