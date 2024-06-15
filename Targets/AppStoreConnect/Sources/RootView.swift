//
//  RootView.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 19.05.2024.
//

import SwiftUI
import AppStoreConnectUI
import AppStoreConnect_Swift_SDK

struct RootView: View {
    var body: some View {
        MainView()
        .frame(width: 500, height: 500)
        .foregroundColor(AppStoreConnectAsset.new.swiftUIColor)
    }
}

#Preview {
    RootView()
}
