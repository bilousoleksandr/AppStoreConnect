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
    public let dependencies: [ModuleDependency]
    public let moduleScripts: [ModuleBuildScript]
    public let hasResources: Bool

    public init(
        name: String,
        product: Product = .framework,
        deploymentTargets: ProjectDescription.DeploymentTargets? = Project.Constants.deploymentsTarget,
        baseBundleId: String = Project.Constants.baseBundleIdentifier,
        dependencies: [ModuleDependency] = [],
        moduleScripts: [ModuleBuildScript] = [],
        hasResources: Bool = false
    ) {
        self.name = name
        self.product = product
        self.deploymentTargets = deploymentTargets
        self.baseBundleId = baseBundleId
        self.dependencies = dependencies
        self.moduleScripts = moduleScripts
        self.hasResources = hasResources
    }
}

extension ModuleConfiguration: TargetConvertiableConfiguration {
    public var productTarget: [ProjectDescription.Target] {
        return ModuleType.allCases.map { module -> ProjectDescription.Target in
            let targetName = module.makeName(name)
            let externalModuleDependencies = dependencies.first { $0.moduleType == module }?.dependencies ?? []
            let scripts = createTargetScripts(for: module)

            return .target(
                name: targetName,
                destinations: .macOS,
                product: module == .tests ? .unitTests : product,
                bundleId: module.makeBundleID(baseBundleId, name),
                deploymentTargets: deploymentTargets,
                sources: [
                    .glob(.path(module.sources(name: name))),
                    .glob(.path(module.generatedFiles(name: name)))
                ],
                scripts: scripts,
                dependencies: dependencies(for: module) + externalModuleDependencies
            )
        }
    }

    private func dependencies(for module: ModuleType) -> [TargetDependency] {
        switch module {
        case .API:
            []
        case .module:
            [.target(name: ModuleType.API.makeName(name))]
        case .mocks:
            [.target(name: ModuleType.API.makeName(name))]
        case .tests:
            [
                .target(name: ModuleType.mocks.makeName(name)),
                .target(name: ModuleType.module.makeName(name)),
            ]
        }
    }

    private func createTargetScripts(
        for module: ModuleType
    ) -> [TargetScript] {
        let buildScripts = moduleScripts.first { $0.moduleType == module }?.buildScripts ?? []
        let inputPaths: [FileListGlob] = module == .mocks ?
            ["\(ModuleType.API.sourcesPath(name: name))"] :
            ["\(module.sourcesPath(name: name))"]


        return buildScripts.map { script -> TargetScript in
            switch script {
            case .sourcery(let sourcery):
                let outputPaths: [ProjectDescription.Path] = sourcery.templates.map {
                    "\(module.generatedPath(name: name))/\($0.fileName)"
                }
                var argumets: [String] = []
                sourcery.templates.forEach { argumets.append("-t \($0.name)") }
                sourcery.imports.forEach { argumets.append("-i \($0)") }

                return .pre(
                    script: "\"${SRCROOT}/Scripts/Sourcery/generate_files.sh\" \(argumets.joined(separator: " "))",
                    name: "[Sourcery] Generate files for target \(module.makeName(name))",
                    inputPaths: inputPaths,
                    outputPaths: outputPaths,
                    basedOnDependencyAnalysis: false
                )
            }
        }
    }
}
