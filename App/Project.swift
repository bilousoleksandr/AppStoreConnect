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
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "AppStoreConnect-Swift-SDK"),
                .external(name: "ComposableArchitecture"),
                .external(name: "KeychainSwift"),
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
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "AppStoreConnect")]
        ),
    ]
)
