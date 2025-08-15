import ComposableArchitecture

@Reducer
struct ApplicationFeature {
    @Dependency(\.appStoreManager) var appStoreManager
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let application: Application
        var reviews: [Review] = []
        var appInfos: [AppInfo] = []
        var selectedView: ViewType = .reviews
        var isLoading: Bool = false
        
        var id: String { application.id }
        
        init(application: Application) {
            self.application = application
        }
    }
    
    enum Action {
        case selectView(ViewType)
        case refreshReviews
        case refreshAppInfo
        case saveReviews([Review])
        case saveAppInfo([AppInfo])
        case setLoading(Bool)
        case loadData
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectView(let viewType):
                state.selectedView = viewType
                return .send(.loadData)
            case .loadData:
                return .run { [state] send in
                    await send(.setLoading(true))
                    if state.selectedView == .reviews {
                        await send(.refreshReviews)
                    } else {
                        await send(.refreshAppInfo)
                    }
                    await send(.setLoading(false))
                }
            case .refreshReviews:
                return .run { [appId = state.application.id] send in
                    let reviews = try await appStoreManager.reviews(for: appId)
                    await send(.saveReviews(reviews))
                }
            case .refreshAppInfo:
                return .run { [appId = state.application.id] send in
                    let appInfos = try await appStoreManager.appInfo(for: appId)
                    await send(.saveAppInfo(appInfos))
                }
            case .saveReviews(let reviews):
                state.reviews = reviews
                return .none
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
