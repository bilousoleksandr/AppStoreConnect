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
            Text("Onboarding with random number \(Int.random(in: 0...Int.max))")
            Button("Finish onboarding") {
                viewModel.dispatchAction(.finishOnboarding)
            }
        }
        .frame(width: 680, height: 400)
    }
}
