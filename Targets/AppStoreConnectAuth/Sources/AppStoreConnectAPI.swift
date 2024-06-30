import Foundation

public final class AppStoreConnectAPI {
//    public static func hello() {
//        print("Hello, from your Auth framework")
//    }
    
    private let authService = AuthorizationService()
    private let sessionManager = SessionManager(storage: UserDefaults.standard)
    
    init() {
        
    }
}
