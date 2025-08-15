import ComposableArchitecture

@Reducer
struct AppRoot {
    @ObservableState
    struct State: Equatable {
        var appFeature: AppFeature.State = .init()
        var settings: SettingFeature.State = .init()
    }
    
    @CasePathable
    enum Action {
        case settings(SettingFeature.Action)
        case appFeature(AppFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.settings, action: \.settings) {
            SettingFeature()
        }
        Scope(state: \.appFeature, action: \.appFeature) {
            AppFeature()
        }
    }
}
