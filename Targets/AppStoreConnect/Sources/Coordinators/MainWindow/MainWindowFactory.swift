//
//  MainWindowFactory.swift
//  AppStoreConnect
//
//  Created by Oleksandr Koval on 30.06.2024.
//  Copyright © 2024 com.bilous. All rights reserved.
//

import Foundation
import AppKit
import AppStoreConnectUI
import SwiftUI
import AppStoreConnectKit
import AppStoreConnectAuth

final class MainWindowFactory {
    private let serviceLocator: ServiceLocator
    private let finish: () -> Void
    private let authorize: () -> Void

    init(
        serviceLocator: ServiceLocator,
        finish: @escaping () -> Void,
        authorize: @escaping () -> Void
    ) {
        self.serviceLocator = serviceLocator
        self.finish = finish
        self.authorize = authorize
    }

    func makeMainWindowViewController() -> NSViewController {
        let view = MainWindowView { [weak self] in
            self?.authorize()
        }

        return NSHostingController(rootView: view)
    }
}


public struct MainWindowView: View {
    
    var authorizeAction: (() -> Void)?
    
    public var body: some View {
        VStack {
            Text("MainView")
            Button("Authorize") {
                authorizeAction?()
            }

        }
        .frame(width: 680, height: 400)
    }
}
