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
        ProductConfiguration(
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
        ProductConfiguration(name: InternalTargetName.appStoreConnectKit.target),
        ProductConfiguration(name: InternalTargetName.appStoreConnectUI.target),
        ProductConfiguration(name: InternalTargetName.appStoreConnectAuth.target),
        ProductConfiguration(name: InternalTargetName.designKit.target, hasResources: true),
        ProductConfiguration(name: InternalTargetName.L10N.target, hasResources: true),
    ]
)


enum InternalTargetName: String {
    case appStoreConnectKit
    case appStoreConnectUI
    case appStoreConnectAuth
    case designKit
    case L10N

    var API: String { rawValue.capitalizedSentence + "API" }
    var target: String { rawValue.capitalizedSentence }
    var tests: String { rawValue.capitalizedSentence + "Tests" }
}

extension TargetDependency {
    enum ThirdParty {
        static let appStoreConnect = TargetDependency.external(name: "AppStoreConnect-Swift-SDK")
    }

    enum Internal {
        static let appStoreConnectKit = TargetDependency.target(name: InternalTargetName.appStoreConnectKit.target)
        static let appStoreConnectUI = TargetDependency.target(name: InternalTargetName.appStoreConnectUI.target)
        static let appStoreConnectAuth = TargetDependency.target(name: InternalTargetName.appStoreConnectAuth.target)
        static let designKit = TargetDependency.target(name: InternalTargetName.designKit.target)
        static let localizations = TargetDependency.target(name: InternalTargetName.L10N.target)
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
