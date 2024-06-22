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
        additionalTargets: [TargetConvertiableConfiguration]
    ) -> Project {
        let targets = additionalTargets.map(\.productTarget).reduce([], +)
        return Project(
            name: name,
            organizationName: organizationName,
            targets: targets,
            additionalFiles: [
                .glob(pattern: "*.md"),
            ],
            resourceSynthesizers: [
                .assets(),
                .strings()
            ]
        )
    }
}
