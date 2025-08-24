import ComposableArchitecture

@Reducer
struct AppInfoFeature {
    @Dependency(\.appStoreManager) var appStoreManager
    
    @ObservableState
    struct State: Equatable {
        var appInfos: [AppInfo] = []
        var isLoading: Bool = false
    }
    
    enum Action {
        case refreshAppInfo(String) // appId parameter
        case saveAppInfo([AppInfo])
        case setLoading(Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .refreshAppInfo(let appId):
                return .run { send in
                    await send(.setLoading(true))
                    do {
                        let appInfos = try await appStoreManager.appInfo(for: appId)
                        await send(.saveAppInfo(appInfos))
                    } catch {
                        // Handle error - could add error state if needed
                        print("Failed to refresh app info: \(error)")
                    }
                    await send(.setLoading(false))
                }
            case .saveAppInfo(let appInfos):
                state.appInfos = appInfos
                return .none
            case .setLoading(let isLoading):
                state.isLoading = isLoading
                return .none
            }
        }
    }
}
