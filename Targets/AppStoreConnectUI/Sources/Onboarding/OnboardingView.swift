//
//  OnboardingView.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import SwiftUI

public struct OnboardingView: View {
    
    @StateObject var viewModel: OnboardingViewModel
    
    public init(viewModel: OnboardingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack {
            Text("This is Onboarding")
        }
    }
}
