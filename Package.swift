// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "ql",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "ql", targets: ["ql"]),
    ],
    dependencies: [
        // none
    ],
    targets: [
        .executableTarget(
            name: "ql",
            dependencies: [],
            path: "source"
        )
    ]
)
