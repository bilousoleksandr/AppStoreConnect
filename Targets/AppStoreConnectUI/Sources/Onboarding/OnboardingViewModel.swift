//
//  OnboardingViewModel.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import Foundation

public final class OnboardingViewModel: ObservableObject {
    // FIXME: - Replace with keyValue storage
    private let userDefaults: UserDefaults
    private let onboarding: Onboarding
    private var finishOnboarding: () -> Void

    public init(
        onboarding: Onboarding,
        userDefaults: UserDefaults,
        finishOnboarding: @escaping () -> Void
    ) {
        self.onboarding = onboarding
        self.userDefaults = userDefaults
        self.finishOnboarding = finishOnboarding
    }
}

extension OnboardingViewModel {
    enum Action {
        case finishOnboarding
    }

    func dispatchAction(_ action: Action) {
        switch action {
        case .finishOnboarding:
            finishOnboarding()
        }
    }
}
