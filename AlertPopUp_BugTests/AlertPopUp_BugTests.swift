import ComposableArchitecture
import XCTest
@testable import AlertPopUp_Bug

@MainActor
final class AlertPopUp_BugTests: XCTestCase {
  
  func testExample() async {
    let todos = IdentifiedArrayOf<TodoRowFeature.State>.mocks
    let store = TestStore(
      initialState: TodoListFeature.State(todos: todos),
      reducer: TodoListFeature()
    )
    
    await store.send(.todo(id: todos.first!.id, action: .deleteButtonTapped)) {
      $0.todos[0].alert = .delete()
    }
    await store.send(.todo(id: todos.first!.id, action: .alert(.presented(.confirmDeletion)))) {
      $0.todos = IdentifiedArray(todos[1...])
    }
  }
  
}
