//
//  WindowDelegate.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 14.06.2024.
//

import Foundation
import AppKit

final class WindowDelegate: NSObject, NSWindowDelegate {
    var windowWillCloseAction: (() -> Void)?

    init(windowWillCloseAction: (() -> Void)? = nil) {
        self.windowWillCloseAction = windowWillCloseAction
    }

    func windowWillClose(_ notification: Notification) {
        windowWillCloseAction?()
    }
}

