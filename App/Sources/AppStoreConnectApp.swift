import SwiftUI
import ComposableArchitecture

@main
struct AppStoreConnectApp: SwiftUI.App {
    let store = Store(initialState: AppRoot.State()) {
        AppRoot()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}


