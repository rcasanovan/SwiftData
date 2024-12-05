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

## Snapshots - Task List view
<p float="left">
  <img src="https://github.com/rcasanovan/astropics/blob/main/Images/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-06-13%20at%2017.13.04.png" width="250" />
  <img src="https://github.com/rcasanovan/astropics/blob/main/Images/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-06-13%20at%2017.13.10.png" width="250" />
  <img src="https://github.com/rcasanovan/astropics/blob/main/Images/Simulator%20Screenshot%20-%20Clone%201%20of%20iPhone%2015%20Pro%20-%202024-08-20%20at%2022.57.14.png" width="250" />
  <img src="https://github.com/rcasanovan/astropics/blob/main/Images/Simulator%20Screenshot%20-%20iPhone%2015%20Pro%20-%202024-06-13%20at%2017.22.35.png" width="250" /> 
</p>

## Additional tools / technologies
* [Swift-format](https://github.com/apple/swift-format): swift-format provides the formatting technology for SourceKit-LSP and the building blocks for doing code formatting transformations.