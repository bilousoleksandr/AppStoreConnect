import ProjectDescription

let workspace = Workspace(
    name: "AppStoreConnect",
    projects: [
        .relativeToRoot("App")
    ],
    fileHeaderTemplate: .string(""),
    additionalFiles: [
        "Configs/**"
    ]
)
