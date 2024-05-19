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
    packages: [
        .remote(url: "https://github.com/AvdLee/appstoreconnect-swift-sdk.git", requirement: .upToNextMajor(from: "3.2.0"))
    ],
    targets: [
        .init(
            name: "AppStoreConnect",
            destinations: .macOS,
            product: .app,
            bundleId: "com.bilous.AppStoreConnect",
            deploymentTargets: .macOS("11.0"),
            infoPlist: .file(path: "Targets/AppStoreConnect/AppStoreConnect-Info.plist"),
            sources: ["Targets/AppStoreConnect/Sources/**"],
            resources: ["Targets/AppStoreConnect/Resources/**"],
            dependencies: [
                Dependencies.ThirdParty.appStoreConnect,
            ]
//            settings: .settings(configurations: [
//                .debug(name: .debug, xcconfig: "Configs/Common.xcconfig"),
//                .release(name: .release, xcconfig: "Configs/Common.xcconfig")
//            ])
        ),
        .init(
            name: "AppStoreConnectTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "com.bilous.AppStoreConnectTests",
            infoPlist: .default,
            sources: ["Targets/AppStoreConnect/Tests/**"],
            resources: [],
            dependencies: [.target(name: "AppStoreConnect")]
        ),
        .init(
            name: "AppStoreConnectKit",
            destinations: .macOS,
            product: .staticFramework,
            bundleId: "com.bilous.AppStoreConnectKit"
        ),
        .init(
            name: "AppStoreConnectUI",
            destinations: .macOS,
            product: .staticFramework,
            bundleId: "com.bilous.AppStoreConnectUI"
        ),
    ],
    additionalFiles: [
        .glob(pattern: "*.md"),
//        .glob(pattern: "**/*.xcconfig")
    ]
)

enum Dependencies {
    enum ThirdParty {
        static let appStoreConnect = TargetDependency.package(product: "AppStoreConnect-Swift-SDK", type: .runtime)
    }
}
