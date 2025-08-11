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


final class ReviewsManager: Sendable {
    private let sessionManager: SessionManager
    private let id = UUID()
    
    init(sessionManager: SessionManager = .init()) {
        self.sessionManager = sessionManager
    }
    
    func apps() async throws -> [Application] {
        let request = APIEndpoint
            .v1
            .apps
            .get(
                parameters: .init(
                    sort: [.bundleID],
                    fieldsApps: [
                        .sku,
                        .appInfos,
                        .name,
                        .bundleID
                    ],
                    limit: 5
                )
            )
        let apps = try await sessionManager.session(for: id).request(request).data
        return apps.compactMap { app -> Application? in
            do {
                let attributes = try app.attributes.get()
                return try Application(
                    id: app.id,
                    name: attributes.name.get(),
                    bundleID: attributes.bundleID.get(),
                    sku: attributes.sku.get()
                )
            } catch {
                return nil
            }
        }
    }
    
    func reviews() async throws -> [Review] {
        let request = APIEndpoint
            .v1
            .apps
            .id("6502719436")
            .customerReviews
            .get(parameters: .init(fieldsCustomerReviews: [
                .createdDate, .body, .title, .reviewerNickname, .rating, .createdDate, .territory
            ]))
        let ratings = try await sessionManager.session(for: id).request(request).data
        print("Did fetch \(ratings) apps")
        return ratings.compactMap { rating -> Review? in
            do {
                let attributes = try rating.attributes.get()
                return try Review(
                    id: rating.id,
                    title: attributes.title.get(),
                    body: attributes.body.get(),
                    createdDate: attributes.createdDate.get(),
                    rating: attributes.rating.get(),
                    reviewerNickname: attributes.reviewerNickname.get(),
                    territoryCode: attributes.territory.get()
                )
            } catch {
                return nil
            }
        }
    }
}

struct Review: Hashable, Equatable, Identifiable {
    let id: String
    let title: String
    let body: String
    let createdDate: Date
    let rating: Int
    let reviewerNickname: String
    let territoryCode: TerritoryCode
}


struct Application: Hashable, Equatable, Identifiable {
    let id: String
    let name: String
    let bundleID: String
    let sku: String
}

extension Optional {
    enum Failure: Swift.Error {
        case missingObject(String)
    }
    
    func get() throws -> Wrapped {
        switch self {
        case .none:
            throw Failure.missingObject("\(Wrapped.self)")
        case .some(let wrapped):
            wrapped
        }
    }
}
