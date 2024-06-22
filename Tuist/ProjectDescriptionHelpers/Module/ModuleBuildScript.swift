//
//  ModuleBuildScript.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 22.06.2024.
//

import Foundation

public struct ModuleBuildScript {
    let moduleType: ModuleType
    let buildScripts: [BuildScript]

    public static func mocks(_ scripts: [BuildScript]) -> ModuleBuildScript {
        ModuleBuildScript(moduleType: .mocks, buildScripts: scripts)
    }

    public static func module(_ scripts: [BuildScript]) -> ModuleBuildScript {
        ModuleBuildScript(moduleType: .module, buildScripts: scripts)
    }

    public static func tests(_ scripts: [BuildScript]) -> ModuleBuildScript {
        ModuleBuildScript(moduleType: .tests, buildScripts: scripts)
    }
}
