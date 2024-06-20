//
//  ModuleConfiguration.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 20.06.2024.
//

import Foundation
import ProjectDescription

public struct ModuleConfiguration {
    public let name: String
    public let product: Product
    public let deploymentTargets: ProjectDescription.DeploymentTargets?
    public let baseBundleId: String
    public let dependencies: [TargetDependency]
    public let hasResources: Bool

    public init(
        name: String,
        product: Product = .dynamicLibrary,
        deploymentTargets: ProjectDescription.DeploymentTargets? = Project.Constants.deploymentsTarget,
        baseBundleId: String = Project.Constants.baseBundleIdentifier,
        dependencies: [TargetDependency] = [],
        hasResources: Bool = false
    ) {
        self.name = name
        self.product = product
        self.deploymentTargets = deploymentTargets
        self.baseBundleId = baseBundleId
        self.dependencies = dependencies
        self.hasResources = hasResources
    }
}

extension ModuleConfiguration: TargetConvertiableConfiguration {
    public var productTarget: [ProjectDescription.Target] {
        [
            .target(
                name: name + "API",
                destinations: .macOS,
                product: product,
                bundleId: baseBundleId + "." + name,
                deploymentTargets: deploymentTargets,
                sources: ["Targets/\(name)Module/API/**"],
                dependencies: dependencies
            ),
            .target(
                name: name + "Mocks",
                destinations: .macOS,
                product: product,
                bundleId: baseBundleId + "." + name,
                deploymentTargets: deploymentTargets,
                sources: ["Targets/\(name)Module/Mocks/**"],
                dependencies: dependencies
            ),
            .target(
                name: name,
                destinations: .macOS,
                product: product,
                bundleId: baseBundleId + "." + name,
                deploymentTargets: deploymentTargets,
                sources: ["Targets/\(name)Module/Sources/**"],
                dependencies: dependencies
            ),
            .target(
                name: name + "Tests",
                destinations: .macOS,
                product: .unitTests,
                bundleId: baseBundleId + "." + name + "Tests",
                deploymentTargets: deploymentTargets,
                sources: ["Targets/\(name)Module/Tests/**"],
                dependencies: dependencies
            ),
        ]
    }
}
