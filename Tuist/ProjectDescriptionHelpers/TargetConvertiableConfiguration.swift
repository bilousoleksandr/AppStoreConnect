//
//  TargetConvertiableConfiguration.swift
//  ProjectDescriptionHelpers
//
//  Created by Oleksandr Bilous on 20.06.2024.
//

import Foundation
import ProjectDescription

public protocol TargetConvertiableConfiguration {
    var productTarget: [ProjectDescription.Target] { get }
}
