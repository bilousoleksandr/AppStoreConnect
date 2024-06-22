//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 20.06.2024.
//

import Foundation

public enum ModuleType: String, CaseIterable {
    case API
    case module
    case mocks
    case tests

    public var suffix: String { rawValue.capitalizedSentence }

    public func makeName(_ baseName: String) -> String {
        switch self {
        case .module:
            baseName
        default:
            [baseName, suffix].joined(separator: "")
        }
    }

    func makeBundleID(_ baseBundleId: String, _ baseName: String) -> String {
        [baseBundleId, baseName, suffix].joined(separator: ".")
    }

    public func sources(for basePath: String = "Targets", name: String) -> String {
        [basePath, "\(name)Module", suffix, "Sources", "**"].joined(separator: "/")
    }

    public func generatedFiles(for basePath: String = "Targets", name: String) -> String {
        [basePath, "\(name)Module", suffix, "Generated", "**"].joined(separator: "/")
    }

    public func generatedPath(for basePath: String = "Targets", name: String) -> String {
        ["$SRCROOT", basePath, "\(name)Module", suffix, "Generated"].joined(separator: "/")
    }

    public func sourcesPath(for basePath: String = "Targets", name: String) -> String {
        ["$SRCROOT", basePath, "\(name)Module", suffix, "Sources"].joined(separator: "/")
    }
}
