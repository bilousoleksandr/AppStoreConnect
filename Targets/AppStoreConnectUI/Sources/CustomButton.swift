//
//  CustomButton.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Bilous on 19.05.2024.
//

import SwiftUI

public struct CustomButton: View {
    public init() {}
    
    public var body: some View {
        Button("Custom Button") {
            print("Button")
        }
    }
}

#Preview {
    CustomButton()
}
