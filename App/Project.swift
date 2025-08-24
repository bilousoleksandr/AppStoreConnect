import ProjectDescription

let project = Project(
    name: "AppStoreConnect",
    settings: .settings(configurations: [
        .debug(name: .debug, xcconfig: .relativeToRoot("Configs/Debug.xcconfig")),
        .release(name: .release, xcconfig: .relativeToRoot("Configs/Release.xcconfig")),
    ]),
    targets: [
        .target(
            name: "AppStoreConnect",
            destinations: .macOS,
            product: .app,
            bundleId: "com.bilous.AppStoreConnect",
            deploymentTargets: .macOS("15.0"),
            infoPlist: .default,
            resources: ["Resources/**"],
            buildableFolders: [.folder("Sources")],
            dependencies: [
                .External.appStoreConnectSDK,
                .External.composableArchitecture,
                .External.keychainSwift,
            ],
            settings: .settings(
                configurations: [
                    .debug(name: .debug, xcconfig: .relativeToRoot("App/Configs/App.xcconfig")),
                    .release(name: .release, xcconfig: .relativeToRoot("App/Configs/App.xcconfig")),
                ],
                defaultSettings: .none
            )
        ),
        .target(
            name: "AppStoreConnectTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "com.bilous.AppStoreConnectTests",
            infoPlist: .default,
            resources: [],
            buildableFolders: [.folder("Tests")],
            dependencies: [.target(name: "AppStoreConnect")]
        ),
    ]
)

extension TargetDependency {
    enum External {
        static let appStoreConnectSDK = TargetDependency.external(name: "AppStoreConnect-Swift-SDK")
        static let composableArchitecture = TargetDependency.external(name: "ComposableArchitecture")
        static let keychainSwift = TargetDependency.external(name: "KeychainSwift")
    }
}
