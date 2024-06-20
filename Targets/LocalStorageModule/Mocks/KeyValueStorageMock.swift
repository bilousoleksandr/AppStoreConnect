//
//  KeyValueStorageMock.swift
//  LocalStorageMocks
//
//  Created by Oleksandr Bilous on 20.06.2024.
//  Copyright © 2024 com.bilous. All rights reserved.
//

import Foundation
import LocalStorageAPI

// MARK: - KeyValueStorageAPIMock -

public final class KeyValueStorageAPIMock: KeyValueStorageAPI {

    // MARK: - setValue

    public var setValueForKeyCallsCount = 0
    public var setValueForKeyCalled: Bool {
        setValueForKeyCallsCount > 0
    }
    public var setValueForKeyReceivedArguments: (value: Any?, key: String)?
    public var setValueForKeyReceivedInvocations: [(value: Any?, key: String)] = []
    public var setValueForKeyClosure: ((Any?, String) -> Void)?

    public func setValue(_ value: Any?, forKey key: String) {
        setValueForKeyCallsCount += 1
        setValueForKeyReceivedArguments = (value: value, key: key)
        setValueForKeyReceivedInvocations.append((value: value, key: key))
        setValueForKeyClosure?(value, key)
    }

    public init() {}
}
