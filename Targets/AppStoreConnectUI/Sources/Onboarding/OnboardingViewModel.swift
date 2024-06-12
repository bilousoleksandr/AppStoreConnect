//
//  OnboardingViewModel.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import Foundation

public final class OnboardingViewModel: ObservableObject {
    private let onboarding: Onboarding
    
    public init(onboarding: Onboarding) {
        self.onboarding = onboarding
        
        OnboardingView(viewModel: self)
    }
}
