import Cocoa
import SwiftUI
import AppStoreConnect_Swift_SDK

class AppDelegate: NSObject, NSApplicationDelegate {
    private let window = NSWindow()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.level = .floating
        window.title = "Hello"
        window.makeKeyAndOrderFront(nil)
        window.makeMain()
        window.contentViewController = NSHostingController(rootView: RootView())
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

}
