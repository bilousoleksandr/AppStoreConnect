import ComposableArchitecture

@Reducer
struct ApplicationFeature {
    @Dependency(\.appStoreManager) var appStoreManager
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let application: Application
        var reviews = ReviewsFeature.State()
        var appInfo = AppInfoFeature.State()
        var selectedView: ViewType = .reviews
        
        var id: String { application.id }
        
        init(application: Application) {
            self.application = application
        }
    }
    
    enum Action {
        case selectView(ViewType)
        case refreshReviews
        case refreshAppInfo
        case loadData
        case reviews(ReviewsFeature.Action)
        case appInfo(AppInfoFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.reviews, action: \.reviews) {
            ReviewsFeature()
        }
        Scope(state: \.appInfo, action: \.appInfo) {
            AppInfoFeature()
        }
        Reduce { state, action in
            switch action {
            case .selectView(let viewType):
                state.selectedView = viewType
                return .send(.loadData)
            case .loadData:
                return .run { [state] send in
                    if state.selectedView == .reviews {
                        await send(.refreshReviews)
                    } else {
                        await send(.refreshAppInfo)
                    }
                }
            case .refreshReviews:
                return .send(.reviews(.refreshReviews(state.application.id)))
            case .refreshAppInfo:
                return .send(.appInfo(.refreshAppInfo(state.application.id)))
            case .reviews:
                return .none
            case .appInfo:
                return .none
            }
        }
    }
}
