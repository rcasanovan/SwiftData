import SwiftData

@Model
public class TaskModel {
  @Attribute(.unique) public var id: String
  public var title: String
  public var isCompleted: Bool

  init(id: String, title: String, isCompleted: Bool = false) {
    self.id = id
    self.title = title
    self.isCompleted = isCompleted
  }
}
