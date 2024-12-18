# SwiftData

This demo implements a very simple app to manage simple task using SwiftData to store the information.


## Architecture

"The Composable Architecture (TCA, for short) is a library for building applications in a consistent and understandable way, with composition, testing, and ergonomics in mind. It can be used in SwiftUI, UIKit, and more, and on any Apple platform (iOS, macOS, tvOS, and watchOS)".


## What is the Composable Architecture?

This library provides a few core tools that can be used to build applications of varying purpose and complexity. It provides compelling stories that you can follow to solve many problems you encounter day-to-day when building applications, such as:

* State management

How to manage the state of your application using simple value types, and share state across many screens so that mutations in one screen can be immediately observed in another screen.

* Composition

How to break down large features into smaller components that can be extracted to their own, isolated modules and be easily glued back together to form the feature.

* Side effects

How to let certain parts of the application talk to the outside world in the most testable and understandable way possible.

* Testing

How to not only test a feature built in the architecture, but also write integration tests for features that have been composed of many parts, and write end-to-end tests to understand how side effects influence your application. This allows you to make strong guarantees that your business logic is running in the way you expect.

* Ergonomics

How to accomplish all of the above in a simple API with as few concepts and moving parts as possible.

## Data flow
<p float="center">
  <img src="https://github.com/rcasanovan/SwiftData/blob/main/Images/TCA_image.001.jpeg"/>
</p>

## Snapshots - Task List view
<p float="left">
  <img src="https://github.com/rcasanovan/SwiftData/blob/main/Images/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-12-05%20at%2015.57.08.png" width="250" />
  <img src="https://github.com/rcasanovan/SwiftData/blob/main/Images/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-12-05%20at%2015.58.09.png" width="250" />
  <img src="https://github.com/rcasanovan/SwiftData/blob/main/Images/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-12-05%20at%2015.58.13.png" width="250" />
  <img src="https://github.com/rcasanovan/SwiftData/blob/main/Images/Simulator%20Screenshot%20-%20iPhone%2016%20Pro%20-%202024-12-05%20at%2015.58.17.png" width="250" /> 
</p>

## Additional tools / technologies
* [Swift-format](https://github.com/apple/swift-format): swift-format provides the formatting technology for SourceKit-LSP and the building blocks for doing code formatting transformations.
* SwiftData: SwiftData is Apple's framework introduced to simplify the management of persistent data in Swift apps. It leverages the Swift language and integrates seamlessly with SwiftUI, offering an easier, more developer-friendly alternative to Core Data, which has traditionally been used for managing complex data models and relationships in iOS/macOS apps.
* Testing: a new native framework introduced by Apple to simplify and modernize the way tests are written in Swift. This framework complements XCTest and is designed to align closely with the Swift language's features, offering a more expressive and Swift-centric way to write tests. It moves away from the more verbose, Objective-C-inspired syntax of XCTest.
