import ComposableArchitecture


@Reducer
struct AppRoot {
    @ObservableState
    struct State: Equatable {
        var appFeature: ApplicationsFeature.State = .init()
        var settings: SettingFeature.State = .init()
        var appDetailFeature: ApplicationFeature.State = .init()
    }
    
    @CasePathable
    enum Action {
        case settings(SettingFeature.Action)
        case appFeature(ApplicationsFeature.Action)
        case appDetailFeature(ApplicationFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.settings, action: \.settings) {
            SettingFeature()
        }
        Scope(state: \.appFeature, action: \.appFeature) {
            ApplicationsFeature()
        }
        Scope(state: \.appDetailFeature, action: \.appDetailFeature) {
            ApplicationFeature()
        }
    }
}

enum ViewType: String, CaseIterable {
    case reviews = "Reviews"
    case appInfo = "App Info"
}
