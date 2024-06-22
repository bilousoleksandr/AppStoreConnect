//
//  Sourcery.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 22.06.2024.
//

import Foundation

public struct Sourcery {
    let imports: [String]
    let templates: [SourceryTemplate]

    public init(
        templates: [SourceryTemplate] = SourceryTemplate.allCases,
        imports: [String] = []
    ) {
        self.templates = templates
        self.imports = imports
    }
}
