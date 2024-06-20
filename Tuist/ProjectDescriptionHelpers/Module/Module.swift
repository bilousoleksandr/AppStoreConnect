//
//  Module.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 20.06.2024.
//

import Foundation

enum Module: String {
    case API
    case sources
    case mocks
    case tests

    var suffix: String { rawValue.capitalizedSentence }

    func makeName(_ baseName: String) -> String {
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
