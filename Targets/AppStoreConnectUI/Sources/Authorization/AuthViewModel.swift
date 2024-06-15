//
//  AuthViewModel.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 21.05.2024.
//

import Foundation

final class AuthViewModel: ObservableObject {
    private let authorization: Authorization
    
    @Published var issuerID = ""
    @Published var privateKeyID = ""
    @Published var privateKey = ""
    
    init(authorization: Authorization) {
        self.authorization = authorization
    }
    
    func authorize() async throws {
        try await authorization.authorize(issuerID: issuerID,
                                          privateKeyID: privateKeyID,
                                          privateKey: privateKey)
    }
    
    var canAuthorize: Bool {
        !issuerID.isEmpty && !privateKeyID.isEmpty && !privateKey.isEmpty
        
        
    }
}
