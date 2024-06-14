//
//  BaseCoordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 14.06.2024.
//

import Foundation
import AppKit

class BaseCoordinator: Coordinator {
    private (set) var children: [Coordinator] = []
    private(set) var rootController: NSViewController?
    var onFinish: (() -> Void)?


    init(_ rootController: NSViewController? = nil) {
        self.rootController = rootController
    }

    func start() {}
}

extension BaseCoordinator {
    func addChild(_ child: Coordinator) {
        children.append(child)
    }

    func removeChild(_ child: Coordinator) {
        let indexToRemove = children.firstIndex { child === $0 }

        guard let indexToRemove else {
            assertionFailure("Could not find child to remove")
            return
        }

        children.remove(at: indexToRemove)
    }
}
