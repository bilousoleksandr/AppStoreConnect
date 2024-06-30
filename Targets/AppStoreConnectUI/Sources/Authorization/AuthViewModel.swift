//
//  AuthViewModel.swift
//  AppStoreConnectUI
//
//  Created by Oleksandr Koval on 21.05.2024.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

public final class AuthViewModel: ObservableObject {
    private let authorization: Authorization
    
    @Published var issuerID = ""
    @Published var privateKeyFileURL: URL? = nil
    
    public init(authorization: Authorization) {
        self.authorization = authorization
    }
    
    lazy var allowedContentTypes: [UTType] = {
        guard let p8UTType = UTType(filenameExtension: "p8")
        else {
            assertionFailure("Failed to obtain .p8 UTType")
            return []
        }
        
        return [p8UTType]
    }()
    
    @Published var isImportingPrivateKey: Bool = false
    
    lazy var onImprotingPrivateKeyFileURL: (Result<URL, Error>) -> Void = { [weak self] result in
        switch result {
        case .success(let url):
            self?.privateKeyFileURL = url
        case .failure(let error):
            print("AuthView failed to pick  Private Key File with error: \(error)")
        }
        
        self?.isImportingPrivateKey = false
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
