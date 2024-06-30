//
//  Authorization.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import Foundation

public protocol Authorization {
    func authorize(issuerID: String, privateKeyFileURL: URL) async throws
}
