//


import ComposableArchitecture

@Reducer
struct ApplicationsFeature {
    @Dependency(\.appStoreManager) var appStoreManager
    
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
                    let apps = try await appStoreManager.apps()
                    await send(.applications(apps))
                }
            case .applications(let apps):
                state.applications = apps
                return .none
            }
        }
    }
}