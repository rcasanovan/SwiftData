import Foundation
import SwiftData

public protocol IdentifiableModel {
  var id: String { get }
}

@Model
public class TaskModel: IdentifiableModel {
  @Attribute(.unique) public var id: String
  public var title: String
  public var createdAt: TimeInterval

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
