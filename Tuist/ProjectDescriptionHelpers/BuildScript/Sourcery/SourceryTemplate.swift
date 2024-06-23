//
//  SourceryTemplate.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 22.06.2024.
//

import Foundation

public enum SourceryTemplate: String, CaseIterable {
    case autoMockable
    case randomizable

    var fileName: String {
        [rawValue.capitalizedSentence, "generated", "swift"].joined(separator: ".")
    }

    var name: String {
        rawValue.capitalizedSentence
    }
}
