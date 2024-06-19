//
//  RootView.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 19.05.2024.
//

import SwiftUI
import AppStoreConnectUI
import DesignKit

struct RootView: View {
    var body: some View {
        MainView()
            .frame(width: 500, height: 500)
            .foregroundColor(DesignKitAsset.Colors.new.swiftUIColor)
    }
}

#Preview {
    RootView()
}
