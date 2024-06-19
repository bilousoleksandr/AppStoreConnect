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
let project = Project.app(
    name: "AppStoreConnect",
    destinations: .macOS,
    additionalTargets: [
        .init(
            name: "AppStoreConnect",
            product: .app,
            infoPlist: .file(path: "Targets/AppStoreConnect/AppStoreConnect-Info.plist"),
            dependencies: [
                .Internal.appStoreConnectKit,
                .Internal.appStoreConnectUI,
                .Internal.designKit,
                .Internal.localizations,
            ]
        ),
        .init(name: InternalTargetName.appStoreConnectKit.name),
        .init(name: InternalTargetName.appStoreConnectUI.name),
        .init(name: InternalTargetName.appStoreConnectAuth.name),
        .init(name: InternalTargetName.designKit.name, hasResources: true),
        .init(name: InternalTargetName.L10N.name, hasResources: true)
    ]
)


enum InternalTargetName: String {
    case appStoreConnectKit
    case appStoreConnectUI
    case appStoreConnectAuth
    case designKit
    case L10N

    var name: String { rawValue.capitalizedSentence }
}

extension TargetDependency {
    enum ThirdParty {
        static let appStoreConnect = TargetDependency.external(name: "AppStoreConnect-Swift-SDK")
    }

    enum Internal {
        static let appStoreConnectKit = TargetDependency.target(name: InternalTargetName.appStoreConnectKit.name)
        static let appStoreConnectUI = TargetDependency.target(name: InternalTargetName.appStoreConnectUI.name)
        static let appStoreConnectAuth = TargetDependency.target(name: InternalTargetName.appStoreConnectAuth.name)
        static let designKit = TargetDependency.target(name: InternalTargetName.designKit.name)
        static let localizations = TargetDependency.target(name: InternalTargetName.L10N.name)
    }
}


extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst()
        // 3
        return firstLetter + remainingLetters
    }
}
