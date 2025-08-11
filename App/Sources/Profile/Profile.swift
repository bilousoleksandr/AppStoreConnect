import Foundation

struct Profile: Identifiable, Sendable {
    typealias ID = UUID
    
    let id: ID
    let name: String
}

actor ProfileService {
    private var profiles: [Profile.ID: Profile] = [:]
    
    init() {
    }
    
    func profiles() async -> [Profile] {
        Array(profiles.values)
    }
    
    func account(for id: Profile.ID) -> Profile? {
        profiles[id]
    }
    
    func saveProfile(profile: Profile) {
        profiles[profile.id] = profile
    }
}


import ComposableArchitecture

@Reducer
struct ApplicationsFeature {
    @Dependency(\.reviewManager) var reviewManager
    
    @ObservableState
    struct State: Equatable {
        var applications: [Application] = []
    }
    
    enum Action {
        case loadApplications
        case applications([Application])
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadApplications:
                return .run { send in
                    let apps = try await reviewManager.apps()
                    await send(.applications(apps))
                }
            case .applications(let apps):
                state.applications = apps
                return .none
            }
        }
    }
}

@Reducer
struct SettingFeature {
    @ObservableState
    struct State: Equatable {
        var applications: [Application] = []
    }
    
    enum Action {
        case open
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .open:
                return .none
            }
        }
    }
}

@Reducer
struct ReviewsFeature {
    @Dependency(\.reviewManager) var reviewManager
    
    @ObservableState
    struct State: Equatable {
        var reviews: [Review] = []
    }
    
    enum Action {
        case refreshReviews
        case saveReview([Review])
        case changeFilter
        case reply
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .refreshReviews:
                return .run { send in
                    let reviews = try await reviewManager.reviews()
                    await send(.saveReview(reviews))
                }
            case .saveReview(let reviews):
                state.reviews = reviews
            case .changeFilter:
                break
            case .reply:
                break
            }
            return .none
        }
    }
}

@Reducer
struct AppRoot {
    @ObservableState
    struct State: Equatable {
        var appFeature: ApplicationsFeature.State = .init()
        var settings: SettingFeature.State = .init()
        var reviewsFeature: ReviewsFeature.State = .init()
    }
    
    @CasePathable
    enum Action {
        case settings(SettingFeature.Action)
        case appFeature(ApplicationsFeature.Action)
        case reviewsFeature(ReviewsFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.settings, action: \.settings) {
            SettingFeature()
        }
        Scope(state: \.appFeature, action: \.appFeature) {
            ApplicationsFeature()
        }
        Scope(state: \.reviewsFeature, action: \.reviewsFeature) {
            ReviewsFeature()
        }
    }
}

import Dependencies


private enum ReviewsManagerKey: DependencyKey {
  static let liveValue = ReviewsManager()
  static let previewValue = ReviewsManager()
  static let testValue = ReviewsManager()
}


extension DependencyValues {
    var reviewManager: ReviewsManager {
        get { self[ReviewsManagerKey.self] }
        set { self[ReviewsManagerKey.self] = newValue }
    }
}
