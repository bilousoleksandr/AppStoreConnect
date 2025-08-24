import Foundation
@preconcurrency import AppStoreConnect_Swift_SDK

actor DeveloperAccountsManager {
    private var configurations: [DeveloperAccount.ID: APIProvider] = [:]
    
    func session(for profileID: DeveloperAccount.ID) throws -> APIProvider {
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


final class AppStoreManager: Sendable {
    private let sessionManager: DeveloperAccountsManager
    private let id = UUID()
    
    init(sessionManager: DeveloperAccountsManager = .init()) {
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
    
    func reviews(for appId: String) async throws -> [Review] {
        let request = APIEndpoint
            .v1
            .apps
            .id(appId)
            .customerReviews
            .get(parameters: .init(
                sort: [.minuscreatedDate],
                fieldsCustomerReviews: [
                    .createdDate, .body, .title, .reviewerNickname, .rating, .createdDate, .territory, .response
                ],
                fieldsCustomerReviewResponses: [.responseBody, .lastModifiedDate, .state, .review],
                include: [.response]
            ))
        let response = try await sessionManager.session(for: id).request(request)
        let reviewsData = response.data
        print("Did fetch \(reviewsData.count) reviews for app \(appId)")
        return reviewsData.compactMap { rating -> Review? in
            do {
                let attributes = try rating.attributes.get()
                
//                rating.type == .customerReviews
//                 Check if there's a review response
                let responseID = rating.relationships?.response?.data?.id
                
                
                var reviewResponse: ReviewResponse? = nil
                if let responseID {
                    let responseAttributes = response.included?.first { $0.id == responseID }?.attributes
                    reviewResponse = try? ReviewResponse(
                        id: responseID,
                        responseBody: responseAttributes.get().responseBody.get(),
                        lastModifiedDate: responseAttributes.get().lastModifiedDate.get(),
                        state: responseAttributes.get().state.get().reviewState
                    )
                }
                
                return try Review(
                    id: rating.id,
                    title: attributes.title.get(),
                    body: attributes.body.get(),
                    createdDate: attributes.createdDate.get(),
                    rating: attributes.rating.get(),
                    reviewerNickname: attributes.reviewerNickname.get(),
                    territoryCode: attributes.territory.get(),
                    response: reviewResponse
                )
            } catch {
                return nil
            }
        }
    }
    
    func createReviewResponse(for reviewId: String, responseBody: String) async throws -> ReviewResponse {
        let requestBody = CustomerReviewResponseV1CreateRequest(
            data: .init(
                type: .customerReviewResponses,
                attributes: .init(responseBody: responseBody),
                relationships: .init(
                    review: .init(data: .init(
                        type: .customerReviews,
                        id: reviewId
                    ))
                )
            )
        )
        
        let request = APIEndpoint
            .v1
            .customerReviewResponses
            .post(requestBody)
        
        let response = try await sessionManager.session(for: id).request(request)
        let attributes = try response.data.attributes.get()
        
        return try ReviewResponse(
            id: response.data.id,
            responseBody: attributes.responseBody.get(),
            lastModifiedDate: attributes.lastModifiedDate.get(),
            state: ReviewResponseState(rawValue: attributes.state.get().rawValue) ?? .pending
        )
    }
    
    func appInfo(for appId: String) async throws -> [AppInfo] {
        let request = APIEndpoint
            .v1
            .apps
            .id(appId)
            .appInfos
            .get(parameters: .init(fieldsAppInfos: [
                .appStoreAgeRating,
                .appStoreState,
                .brazilAgeRating,
                .kidsAgeBand,
                .primaryCategory,
                .primarySubcategoryOne,
                .primarySubcategoryTwo,
                .secondaryCategory,
                .secondarySubcategoryOne,
                .secondarySubcategoryTwo
            ]))
        let appInfos = try await sessionManager.session(for: id).request(request).data
        print("Did fetch \(appInfos.count) app infos")
        return appInfos.compactMap { appInfo -> AppInfo? in
            do {
                let attributes = try appInfo.attributes.get()
                return try AppInfo(
                    id: appInfo.id,
                    appStoreAgeRating: attributes.appStoreAgeRating.get(),
                    appStoreState: attributes.appStoreState.get(),
                    brazilAgeRating: attributes.brazilAgeRating.get(),
                    kidsAgeBand: attributes.kidsAgeBand.get()
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
    var response: ReviewResponse?
}

struct ReviewResponse: Hashable, Equatable, Identifiable {
    let id: String
    let responseBody: String
    let lastModifiedDate: Date
    let state: ReviewResponseState
}

enum ReviewResponseState: String, CaseIterable {
    case published = "PUBLISHED"
    case pending = "PENDING_PUBLISH"
}

extension CustomerReviewResponseV1.Attributes.State {
    var reviewState: ReviewResponseState {
        switch self {
        case .published:
            .published
        case .pendingPublish:
            .pending
        }
    }
}


struct Application: Hashable, Equatable, Identifiable {
    let id: String
    let name: String
    let bundleID: String
    let sku: String
}

struct AppInfo: Hashable, Equatable, Identifiable {
    let id: String
    let appStoreAgeRating: AppStoreAgeRating
    let appStoreState: AppStoreVersionState
    let brazilAgeRating: BrazilAgeRating
    let kidsAgeBand: KidsAgeBand
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
