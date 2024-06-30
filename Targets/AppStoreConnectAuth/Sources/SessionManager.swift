//
//  SessionManager.swift
//  AppStoreConnectAuth
//
//  Created by Oleksandr Koval on 30.06.2024.
//  Copyright © 2024 com.bilous. All rights reserved.
//

import Foundation
import LocalStorageAPI

struct Session {
    let issuerId: String
    let privateKeyId: String
    let privateKey: String
}

final class SessionManager {
    
    private let storage: KeyValueStorageProtocol
    
    init(storage: KeyValueStorageProtocol) {
        self.storage = storage
    }
    
    func store(session: Session, forKey key: String) async throws {
        
    }
    
    func getSession(forKey key: String) async throws -> Session {
        Session(issuerId: "", privateKeyId: "", privateKey: "")
    }
    
}
