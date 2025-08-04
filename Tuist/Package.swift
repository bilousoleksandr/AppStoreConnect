// swift-tools-version: 6.1
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "AppStoreConnect",
    dependencies: [
        // Add your own dependencies here:
         .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.21.0"),
         .package(url: "https://github.com/evgenyneu/keychain-swift", from: "24.0.0"),
         .package(url: "https://github.com/AvdLee/appstoreconnect-swift-sdk", from: "4.0.2"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
    ]
)
