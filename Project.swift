import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains AppStoreConnect App target and AppStoreConnect unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project(
    name: "AppStoreConnect",
    targets: [
        .target(
            name: "AppStoreConnect",
            destinations: .macOS,
            product: .app,
            bundleId: "com.bilous.AppStoreConnect",
            deploymentTargets: .macOS("14.0"),
            infoPlist: .file(path: "Targets/AppStoreConnect/AppStoreConnect-Info.plist"),
            sources: ["Targets/AppStoreConnect/Sources/**"],
            resources: ["Targets/AppStoreConnect/Resources/**"],
            dependencies: [
                Dependencies.Internal.appStoreConnectKit,
                Dependencies.Internal.appStoreConnectUI,
            ]
        ),
        .target(
            name: "AppStoreConnectTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "com.bilous.AppStoreConnectTests",
            infoPlist: .default,
            sources: ["Targets/AppStoreConnect/Tests/**"],
            resources: [],
            dependencies: [.target(name: "AppStoreConnect")]
        ),
        .target(
            name: "AppStoreConnectKit",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.bilous.AppStoreConnectKit",
            deploymentTargets: .macOS("14.0"),
            sources: ["Targets/AppStoreConnectKit/Sources/**"],
            dependencies: [
                Dependencies.Internal.appStoreConnectAuth,
            ]
        ),
        .target(
            name: "AppStoreConnectAuth",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.bilous.AppStoreConnectAuth",
            deploymentTargets: .macOS("14.0"),
            sources: ["Targets/AppStoreConnectAuth/Sources/**"],
            dependencies: [
                Dependencies.ThirdParty.appStoreConnect,
            ]
        ),
        .target(
            name: "AppStoreConnectUI",
            destinations: .macOS,
            product: .framework,
            bundleId: "com.bilous.AppStoreConnectUI",
            deploymentTargets: .macOS("14.0"),
            sources: ["Targets/AppStoreConnectUI/Sources/**"]
        ),
    ],
    additionalFiles: [
        .glob(pattern: "*.md"),
        .glob(pattern: "**/*.xcconfig")
    ],
    resourceSynthesizers: [.assets()]
)

enum Dependencies {
    enum ThirdParty {
        static let appStoreConnect = TargetDependency.external(name: "AppStoreConnect-Swift-SDK")
    }

    enum Internal {
        static let appStoreConnectKit = TargetDependency.target(name: "AppStoreConnectKit")
        static let appStoreConnectUI = TargetDependency.target(name: "AppStoreConnectUI")
        static let appStoreConnectAuth = TargetDependency.target(name: "AppStoreConnectAuth")
    }
}
