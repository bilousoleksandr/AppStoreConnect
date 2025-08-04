import ProjectDescription

let project = Project(
    name: "AppStoreConnect",
    targets: [
        .target(
            name: "AppStoreConnect",
            destinations: .macOS,
            product: .app,
            bundleId: "io.tuist.AppStoreConnect",
            infoPlist: .default,
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "AppStoreConnectTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.tuist.AppStoreConnectTests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [.target(name: "AppStoreConnect")]
        ),
    ]
)
