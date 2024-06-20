//
//  WindowDelegate.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 14.06.2024.
//

import Foundation
import AppKit

public final class WindowDelegate: NSObject, NSWindowDelegate {
    public var windowWillCloseAction: (() -> Void)?

    public init(windowWillCloseAction: (() -> Void)? = nil) {
        self.windowWillCloseAction = windowWillCloseAction
    }

    public func windowWillClose(_ notification: Notification) {
        windowWillCloseAction?()
    }
}

