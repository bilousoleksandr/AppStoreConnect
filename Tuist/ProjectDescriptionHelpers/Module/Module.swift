//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 20.06.2024.
//

import Foundation

public enum Module: String {
    case API
    case sources
    case mocks
    case tests

    public var suffix: String { rawValue.capitalizedSentence }

    public func makeName(_ baseName: String) -> String {
        switch self {
        case .sources:
            baseName
        default:
            [baseName, suffix].joined(separator: "")
        }
    }

    func makeBundleID(_ baseBundleId: String, _ baseName: String) -> String {
        [baseBundleId, baseName, suffix].joined(separator: ".")
    }
}
