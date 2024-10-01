import Foundation
import SwiftData

@Model
public class TaskModel {
  @Attribute(.unique) public var id: String
  public var title: String
  public var isCompleted: Bool
  public var createdAt: TimeInterval

  init(
    id: String,
    title: String,
    isCompleted: Bool = false,
    createdAt: TimeInterval = Date().timeIntervalSince1970
  ) {
    self.id = id
    self.title = title
    self.isCompleted = isCompleted
    self.createdAt = createdAt
  }
}
