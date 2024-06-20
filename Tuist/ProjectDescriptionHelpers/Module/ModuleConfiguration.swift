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
                name: Module.API.makeName(name),
                destinations: .macOS,
                product: product,
                bundleId: Module.API.makeBundleID(baseBundleId, name),
                deploymentTargets: deploymentTargets,
                sources: ["Targets/\(name)Module/\(Module.API.suffix)/**"]
            ),
            .target(
                name: Module.mocks.makeName(name),
                destinations: .macOS,
                product: product,
                bundleId: Module.mocks.makeBundleID(baseBundleId, name),
                deploymentTargets: deploymentTargets,
                sources: ["Targets/\(name)Module/\(Module.mocks.suffix)/**"],
                dependencies: [.target(name: Module.API.makeName(name))]
            ),
            .target(
                name: name,
                destinations: .macOS,
                product: product,
                bundleId: Module.sources.makeBundleID(baseBundleId, name),
                deploymentTargets: deploymentTargets,
                sources: ["Targets/\(name)Module/\(Module.sources.suffix)/**"],
                dependencies: dependencies + [.target(name: Module.API.makeName(name))]
            ),
            .target(
                name: Module.tests.makeName(name),
                destinations: .macOS,
                product: .unitTests,
                bundleId: Module.tests.makeBundleID(baseBundleId, name),
                deploymentTargets: deploymentTargets,
                sources: ["Targets/\(name)Module/\(Module.tests.suffix)/**"],
                dependencies: [
                    .target(name: Module.mocks.makeName(name)),
                    .target(name: Module.API.makeName(name)),
                    .target(name: Module.sources.makeName(name)),
                ]
            ),
        ]
    }
}
