//
//  AuthViewModel.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 21.05.2024.
//

import Foundation

public final class AuthViewModel: ObservableObject {
    private let authorization: Authorization
    
    @Published var issuerID = ""
    @Published var privateKeyFileURL: URL? = nil
    
    public init(authorization: Authorization) {
        self.authorization = authorization
    }
    
    func authorize() async {
        guard let privateKeyFileURL,
              !issuerID.isEmpty
        else {
            assertionFailure("privateKeyFileURL is not set or issuerID is empty")
            return
        }

        do {
            try await authorization.authorize(issuerID: issuerID,
                                              privateKeyFileURL: privateKeyFileURL)
        }
        catch {
            print("\(error)")
        }
    }
    
    var canAuthorize: Bool {
        !issuerID.isEmpty && nil != privateKeyFileURL
    }
}
