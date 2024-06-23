//
//  File.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 20.06.2024.
//

import Foundation
import ProjectDescription

public struct ProductConfiguration {
    public let name: String
    public let product: Product
    public let deploymentTargets: ProjectDescription.DeploymentTargets?
    public let baseBundleId: String
    public let infoPlist: InfoPlist?
    public let dependencies: [TargetDependency]
    public let hasResources: Bool

    public init(
        name: String,
        product: Product = .framework,
        deploymentTargets: ProjectDescription.DeploymentTargets? = Project.Constants.deploymentsTarget,
        baseBundleId: String = Project.Constants.baseBundleIdentifier,
        infoPlist: InfoPlist? = nil,
        dependencies: [TargetDependency] = [],
        hasResources: Bool = false
    ) {
        self.name = name
        self.product = product
        self.deploymentTargets = deploymentTargets
        self.baseBundleId = baseBundleId
        self.infoPlist = infoPlist
        self.dependencies = dependencies
        self.hasResources = hasResources
    }
}

extension ProductConfiguration: TargetConvertiableConfiguration {
    public var productTarget: [ProjectDescription.Target] {
        [
            .target(
                name: name,
                destinations: .macOS,
                product: product,
                bundleId: baseBundleId + "." + name,
                deploymentTargets: deploymentTargets,
                infoPlist: infoPlist ?? .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: hasResources ? ["Targets/\(name)/Resources/**"] : [],
                dependencies: dependencies
            ),
            .target(
                name: name + "Tests",
                destinations: .macOS,
                product: .unitTests,
                bundleId: baseBundleId + "." + name + "Tests",
                deploymentTargets: deploymentTargets,
                infoPlist: .default,
                sources: ["Targets/\(name)/Tests/**"],
                resources: hasResources ? ["Targets/\(name)/Resources/**"] : [],
                dependencies: dependencies
            ),
        ]
    }
}
