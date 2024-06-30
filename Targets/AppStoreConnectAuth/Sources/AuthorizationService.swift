//
//  AuthorizationService.swift
//  AppStoreConnectAuth
//
//  Created by Oleksandr Koval on 15.06.2024.
//

import Foundation
import AppStoreConnect_Swift_SDK

public final class AuthorizationService {
        
    public init() {}
    
    public func authorize(issuerID: String, privateKeyFileURL: URL) async throws {
        do {
            let configuration = try APIConfiguration(issuerID: issuerID,
                                                     privateKeyURL: privateKeyFileURL)
            
            let apiProvider = APIProvider(configuration: configuration)
            
            let request = APIEndpoint
                .v1
                .apps
                .get(parameters: .init(
                    sort: [.bundleID],
                    fieldsApps: [.appInfos, .name, .bundleID],
                    limit: 5
                ))
            
            _ = try await apiProvider.request(request).data
        }
        catch {
            throw error
        }
    }
    
    func authorize(session: Session) async throws -> Bool {
        false
    }
}
