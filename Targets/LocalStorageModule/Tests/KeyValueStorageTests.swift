//
//  KeyValueStorageTests.swift
//  LocalStorageTests
//
//  Created by Oleksandr Bilous on 20.06.2024.
//  Copyright © 2024 com.bilous. All rights reserved.
//

import XCTest
import LocalStorageAPI
import LocalStorageMocks
@testable import LocalStorage

final class KeyValueStorageTests: XCTestCase {
    private lazy var sut = KeyValueStorageAPIMock()

    func testExample() throws {
        // GIVEN
        let value = UUID().uuidString

        // WHEN
        sut.setValue(value, forKey: UUID().uuidString)

        // THEN
        XCTAssertEqual(value, value)
    }
}
