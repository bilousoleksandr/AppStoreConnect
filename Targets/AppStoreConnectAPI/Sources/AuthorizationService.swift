//
//  AuthorizationService.swift
//  AppStoreConnectAuth
//
//  Created by Oleksandr Koval on 15.06.2024.
//

import Foundation
import AppStoreConnect_Swift_SDK

public final class AuthorizationService {
    
    private var apiProvider: APIProvider?
    
    public init() {}
    
    public func authorize(issuerID: String, privateKeyFileURL: URL) async throws {
        do {
            let configuration = try APIConfiguration(issuerID: issuerID,
                                                     privateKeyURL: privateKeyFileURL)
            
            apiProvider = APIProvider(configuration: configuration)
            
            let request = APIEndpoint
                .v1
                .apps
                .get(parameters: .init(
                    sort: [.bundleID],
                    fieldsApps: [.appInfos, .name, .bundleID],
                    limit: 5
                ))
            
            let apps = try await apiProvider!.request(request).data
            
            print("Did fetch \(apps.count) apps")
        }
        catch {
            throw error
        }
    }
}
