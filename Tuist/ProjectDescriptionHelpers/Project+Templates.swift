import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(
        name: String,
        destinations: Destinations,
        organizationName: String = "com.bilous",
        additionalTargets: [ProductConfiguration]
    ) -> Project {
        return Project(
            name: name,
            organizationName: organizationName,
            targets: additionalTargets.map { makeProductTarget(from: $0) },
            additionalFiles: [
                .glob(pattern: "*.md"),
                .glob(pattern: "**/*.xcconfig")
            ],
            resourceSynthesizers: [
                .assets(),
                .strings()
            ]
        )
    }

    static func makeProductTarget(
        from configuration: ProductConfiguration
    ) -> ProjectDescription.Target {
        .target(
            name: configuration.name,
            destinations: .macOS,
            product: configuration.product,
            bundleId: configuration.baseBundleId + "." + configuration.name,
            deploymentTargets: configuration.deploymentTargets,
            sources: ["Targets/\(configuration.name)/Sources/**"],
            resources: configuration.hasResources ? ["Targets/\(configuration.name)/Resources/**"] : [],
            dependencies: configuration.dependencies
        )
    }
}


public struct ProductConfiguration {
    public let name: String
    public let product: Product
    public let deploymentTargets: ProjectDescription.DeploymentTargets?
    public let baseBundleId: String
    public let dependencies: [TargetDependency]
    public let hasResources: Bool

    public init(
        name: String,
        product: Product = .framework,
        deploymentTargets: ProjectDescription.DeploymentTargets? = .macOS("14.0"),
        baseBundleId: String = Project.Constants.baseBundleIdentifier,
        dependencies: [TargetDependency] = [],
        hasResources: Bool = false
    ) {
        self.name = name
        self.product = product
        self.deploymentTargets = deploymentTargets
        self.baseBundleId = baseBundleId
        self.dependencies = dependencies
        self.hasResources = hasResources
    }
}


extension Project {
    public enum Constants {
        public static let baseBundleIdentifier = "com.bilous"
    }
}
