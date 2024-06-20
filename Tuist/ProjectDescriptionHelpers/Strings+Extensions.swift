//
//  Strings+Extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 20.06.2024.
//

import Foundation

public extension String {
    var capitalizedSentence: String {
        return prefix(1).capitalized + dropFirst()
    }
}
