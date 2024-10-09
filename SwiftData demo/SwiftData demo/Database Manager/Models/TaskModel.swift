import Foundation
import SwiftData

/// A model class representing a task in the application.
///
/// The `TaskModel` class conforms to `IdentifiableModel` and contains attributes for storing task details.
/// It has a unique identifier (`id`), a `title`, and a `createdAt` timestamp indicating when the task was created.
@Model
public class TaskModel: IdentifiableModel {
  @Attribute(.unique) public var id: String  // A unique identifier for the task.
  public var title: String  // The title of the task.
  public var createdAt: TimeInterval  // The timestamp when the task was created.

  init(
    id: String,
    title: String,
    createdAt: TimeInterval = Date().timeIntervalSince1970
  ) {
    self.id = id
    self.title = title
    self.createdAt = createdAt
  }
}
