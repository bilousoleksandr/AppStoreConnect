import ComposableArchitecture

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
