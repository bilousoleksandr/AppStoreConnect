//
import ComposableArchitecture

@Reducer
struct ApplicationFeature {
    @Dependency(\.appStoreManager) var appStoreManager
    
    @ObservableState
    struct State: Equatable {
        var selectedApp: Application?
        var reviews: [Review] = []
        var appInfos: [AppInfo] = []
        var selectedView: ViewType = .reviews
        var isLoading: Bool = false
    }
    
    enum Action {
        case selectApp(Application)
        case selectView(ViewType)
        case refreshReviews
        case refreshAppInfo
        case saveReviews([Review])
        case saveAppInfo([AppInfo])
        case setLoading(Bool)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectApp(let app):
                state.selectedApp = app
                state.reviews = []
                state.appInfos = []
                return .run { [state] send in
                    await send(.setLoading(true))
                    if state.selectedView == .reviews {
                        await send(.refreshReviews)
                    } else {
                        await send(.refreshAppInfo)
                    }
                    await send(.setLoading(false))
                }
            case .selectView(let viewType):
                state.selectedView = viewType
                if let app = state.selectedApp {
                    return .run { send in
                        await send(.setLoading(true))
                        if viewType == .reviews {
                            await send(.refreshReviews)
                        } else {
                            await send(.refreshAppInfo)
                        }
                        await send(.setLoading(false))
                    }
                }
                return .none
            case .refreshReviews:
                guard let appId = state.selectedApp?.id else { return .none }
                return .run { send in
                    let reviews = try await appStoreManager.reviews(for: appId)
                    await send(.saveReviews(reviews))
                }
            case .refreshAppInfo:
                guard let appId = state.selectedApp?.id else { return .none }
                return .run { send in
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
