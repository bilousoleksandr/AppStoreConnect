//
//  RootView.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 19.05.2024.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            Button("Hello") {
                print("Hello")
            }
        }
        .frame(width: 500, height: 500)
    }
}

#Preview {
    RootView()
}
