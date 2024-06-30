import Cocoa
import SwiftUI
import AppStoreConnectKit
import LocalStorageAPI

class AppDelegate: NSObject, NSApplicationDelegate {
    private let window = NSWindow()
    private let serviceLocator = ServiceLocatorImpl()
    private lazy var appCoordinator = RootCoordinator(
        serviceLocator: serviceLocator
    )

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        serviceLocator.register(service: UserDefaults.standard, type: UserDefaults.self)
        
        serviceLocator.register(service: UserDefaults.standard, type: KeyValueStorageProtocol.self)

        let storage = serviceLocator.resolve(KeyValueStorageProtocol.self)
        
        let launchesCount = storage.integer(forKey: StorageKeys.launchCount)
        
        storage.setValue(launchesCount + 1, forKey: StorageKeys.launchCount)
        
        appCoordinator.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

}
