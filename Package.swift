// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "FlowObservable",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "FlowObservable",
            targets: ["FlowObservable"]),
    ],
    dependencies: [],
    targets: [
          .target(
              name: "FlowObservable",
              dependencies: [],
              path: "FlowObservable"
          )
    ]
)
