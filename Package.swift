// swift-tools-version:5.0
import PackageDescription

let package = Package(
   name: "InputBarAccessoryView",
   platforms: [.iOS(.v11)],
   products: [
       .library(
            name: "InputBarAccessoryView",
            targets: ["InputBarAccessoryView"])
   ],
   targets: [
       .target(
           name: "InputBarAccessoryView",
           path: "Sources"
       )
   ],
   swiftLanguageVersions: [.v5]
)
