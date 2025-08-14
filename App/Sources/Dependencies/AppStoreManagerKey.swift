import Dependencies


private enum AppStoreManagerKey: DependencyKey {
  static let liveValue = AppStoreManager()
  static let previewValue = AppStoreManager()
  static let testValue = AppStoreManager()
}


extension DependencyValues {
    var appStoreManager: AppStoreManager {
        get { self[AppStoreManagerKey.self] }
        set { self[AppStoreManagerKey.self] = newValue }
    }
}
