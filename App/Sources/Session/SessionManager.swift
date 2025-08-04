import Foundation
@preconcurrency import AppStoreConnect_Swift_SDK

actor SessionManager {
    private var configurations: [Profile.ID: APIProvider] = [:]
    
    func session(for profileID: Profile.ID) throws -> APIProvider {
        if let configuration = configurations[profileID] {
            return configuration
        }
        
        let privateKeyURL = Bundle.module.url(
            forResource: "AuthKey_8GF86G4K7S.p8",
            withExtension: nil
        )!
        let configuration = try APIConfiguration(
            issuerID: "02209cd6-a9ec-40b8-b274-91cd8942cabd",
            privateKeyURL: privateKeyURL
        )
        
        let provider = APIProvider(configuration: configuration)
        self.configurations[profileID] = provider
        return provider
    }
}


final class ReviewsManager {
    private let sessionManager: SessionManager
    private let id = UUID()
    
    init(sessionManager: SessionManager = .init()) {
        self.sessionManager = sessionManager
    }
    
    func apps() async throws {
        let request = APIEndpoint
            .v1
            .apps
            .get(parameters: .init(
                sort: [.bundleID],
                fieldsApps: [.appInfos, .name, .bundleID],
                limit: 5
            ))
        let apps = try await sessionManager.session(for: id).request(request).data
        print("Did fetch \(apps) apps")
    }
    
    func reviews() async throws {
        let request = APIEndpoint
            .v1
            .apps
            .id("6502719436")
            .customerReviews
            .get(parameters: .init(fieldsCustomerReviews: [
                .createdDate, .body, .title
            ]))
        let ratings = try await sessionManager.session(for: id).request(request).data
        print("Did fetch \(ratings) apps")
    }
}



