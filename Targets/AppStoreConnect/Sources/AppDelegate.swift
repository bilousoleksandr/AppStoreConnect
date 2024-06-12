import Cocoa
import SwiftUI
import AppStoreConnect_Swift_SDK
import AppStoreConnectKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private let window = NSWindow()
    private let serviceLocator = ServiceLocatorImpl()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.level = .floating
        window.title = "Hello"
        window.makeKeyAndOrderFront(nil)
        window.makeMain()
        window.contentViewController = NSHostingController(rootView: RootView())
        
        serviceLocator.register(service: UserDefaults.standard, type: UserDefaults.self)
        
        serviceLocator.register(service: UserDefaults.standard, type: KeyValueStorage.self)

        
        let userDefaults = serviceLocator.resolve(UserDefaults.self)
        
        let keyValueStorage = serviceLocator.resolve(KeyValueStorage.self)
        
        let readableKeyValueStorage = serviceLocator.resolve(ReadableKeyValueStorage.self)

        
        print("")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

}
