//
//  KeyValueStorage.swift
//  AppStoreConnect
//
//  Created by Oleksandr Koval on 12.06.2024.
//

import Foundation


typealias NewProtocol = KeyValueStorage & AuthorizationService

protocol KeyValueStorage: ReadableKeyValueStorage {
    func setValue(_ value: Any?, forKey key: String)
}

protocol ReadableKeyValueStorage: AnyObject {
    func value(forKey key: String) -> Any?
}

extension UserDefaults: KeyValueStorage {}

protocol AuthorizationService {
    var isAuthorized: Bool { get } 
    
}
