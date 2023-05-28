import IdentifiedCollections
import Foundation

struct TodoModel: Equatable, Identifiable {
  let id: UUID = .init()
  var title: String = ""
  var isCompleted: Bool = false
}

extension TodoModel {
  static let mocks: [Self] = [
    .init(title: "Buy milk", isCompleted: Bool.random()),
    .init(title: "Buy eggs", isCompleted: Bool.random()),
    .init(title: "Walk the dogs", isCompleted: Bool.random()),
    .init(title: "Take out the garbage", isCompleted: Bool.random()),
    .init(title: "Order cups", isCompleted: Bool.random()),
  ]
}

extension IdentifiedArrayOf<TodoRowFeature.State> {
  static let mocks = Self.init(
    uniqueElements: TodoModel.mocks.map { todo in
      TodoRowFeature.State.init(todo: todo)
    }
  )
}
