import Dependencies
import IdentifiedCollections
import Foundation

struct TodoModel: Equatable, Identifiable {
  let id: UUID
  var title: String = ""
  var isCompleted: Bool = false
}

extension TodoModel {
  
  static func mocks() -> [Self] {
    @Dependency(\.uuid) var uuid;
    return [
      .init(id: uuid(), title: "Buy milk", isCompleted: Bool.random()),
      .init(id: uuid(), title: "Buy eggs", isCompleted: Bool.random()),
      .init(id: uuid(), title: "Walk the dogs", isCompleted: Bool.random()),
      .init(id: uuid(), title: "Take out the garbage", isCompleted: Bool.random()),
      .init(id: uuid(), title: "Order cups", isCompleted: Bool.random()),
    ]
  }
}

extension IdentifiedArrayOf<TodoRowFeature.State> {
  static let mocks = Self.init(
    uniqueElements: TodoModel.mocks().map { todo in
      TodoRowFeature.State.init(todo: todo)
    }
  )
}
