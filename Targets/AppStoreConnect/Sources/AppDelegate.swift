import Cocoa
import SwiftUI
import AppStoreConnect_Swift_SDK
import AppStoreConnectKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private let window = NSWindow()
    private let serviceLocator = ServiceLocatorImpl()
    private lazy var appCoordinator = RootCoordinator(
        serviceLocator: serviceLocator
    )

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        serviceLocator.register(service: UserDefaults.standard, type: UserDefaults.self)
        
        serviceLocator.register(service: UserDefaults.standard, type: KeyValueStorage.self)

        
        appCoordinator.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

}
