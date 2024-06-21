// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
    productTypes: [
        "Alamofire": .framework, // default is .staticFramework
        "AppStoreConnect-Swift-SDK": .staticFramework
    ]
)

#endif

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(url: "https://github.com/AvdLee/appstoreconnect-swift-sdk", from: "3.3.0")
    ]
)
