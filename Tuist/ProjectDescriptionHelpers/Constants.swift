//
//  Constants.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 20.06.2024.
//

import Foundation
import ProjectDescription

extension Project {
    public enum Constants {
        public static let baseBundleIdentifier = "com.bilous"
        public static let deploymentsTarget: ProjectDescription.DeploymentTargets? = .macOS("14.0")
    }
}
