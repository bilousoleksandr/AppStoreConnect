//
//  KeyValueStorage.swift
//  LocalStorageAPI
//
//  Created by Oleksandr Bilous on 20.06.2024.
//  Copyright © 2024 com.bilous. All rights reserved.
//

import Foundation

// sourcery: AutoMockable
public protocol KeyValueStorageProtocol {
    func setValue(_ value: Any?, forKey key: String)
}
