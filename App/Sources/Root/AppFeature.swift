import ComposableArchitecture
@Reducer
struct AppFeature {
    @Dependency(\.appStoreManager) var appStoreManager
    
    @ObservableState
    struct State: Equatable {
        var applicationFeatures: IdentifiedArrayOf<ApplicationFeature.State> = []
        var selectedApplicationId: String?
        var isLoadingApplications: Bool = false
    }
    
    enum Action {
        case loadApplications
        case saveApplications([Application])
        case selectApplication(String)
        case applicationFeature(IdentifiedActionOf<ApplicationFeature>)
        case setLoadingApplications(Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadApplications:
                return .run { send in
                    await send(.setLoadingApplications(true))
                    let apps = try await appStoreManager.apps()
                    await send(.saveApplications(apps))
                    await send(.setLoadingApplications(false))
                }
            case .saveApplications(let applications):
                state.applicationFeatures = IdentifiedArrayOf(
                    uniqueElements: applications.map { ApplicationFeature.State(application: $0) }
                )
                return .none
            case .selectApplication(let appId):
                state.selectedApplicationId = appId
                // Load data for the selected application
                return .send(.applicationFeature(.element(id: appId, action: .loadData)))
            case .setLoadingApplications(let isLoading):
                state.isLoadingApplications = isLoading
                return .none
            case .applicationFeature:
                return .none
            }
        }
        .forEach(\.applicationFeatures, action: \.applicationFeature, element: ApplicationFeature.init)
//        .forEach(\.applicationFeatures, action: \.applicationFeature)
//        .forEach(\.applicationFeatures, action: /Action.applicationFeature) {
//            ApplicationFeature()
//        }
    }
}

@Reducer
struct SettingFeature {
    @ObservableState
    struct State: Equatable {
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
