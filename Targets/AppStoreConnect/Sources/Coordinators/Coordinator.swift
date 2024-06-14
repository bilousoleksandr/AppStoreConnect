//
//  Coordinator.swift
//  AppStoreConnect
//
//  Created by Oleksandr Bilous on 14.06.2024.
//

import Foundation
import AppKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get }

    func start()

    var rootController: NSViewController? { get }
}
