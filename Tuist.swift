import ProjectDescription

let tuist = Tuist(
    project: .tuist(
        compatibleXcodeVersions: .exact(.init(16, 4, 0)),
        swiftVersion: "6.0",
        plugins: []
    )
)
