//
//  AsyncButton.swift
//  DesignKit
//
//  Created by Oleksandr Koval on 24.06.2024.
//  Copyright © 2024 com.bilous. All rights reserved.
//

import SwiftUI

public struct AsyncButton<Label: View>: View {
    let action: () async -> Void
    let label: Label
    
    @State private var isRunning = false
    private var disabled = false
    
    public init(
        disabled: Bool = false,
        action: @escaping () async -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.action = action
        self.label = label()
        self.disabled = disabled
    }
    
    public var body: some View {
        Button {
            isRunning = true
            Task {
                await action()
                isRunning = false
            }
        } label: {
            label
        }
        .disabled(isRunning ||  disabled)
    }
}
