//
//  ModuleDependency.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 22.06.2024.
//

import Foundation
import ProjectDescription

public struct ModuleDependency {
    let moduleType: ModuleType
    let dependencies: [TargetDependency]

    public static func module(_ dependencies: [TargetDependency]) -> ModuleDependency {
        ModuleDependency(moduleType: .module, dependencies: dependencies)
    }

    public static func tests(_ dependencies: [TargetDependency]) -> ModuleDependency {
        ModuleDependency(moduleType: .tests, dependencies: dependencies)
    }
}
