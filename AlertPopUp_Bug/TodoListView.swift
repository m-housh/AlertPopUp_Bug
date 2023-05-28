import ComposableArchitecture
import SwiftUI

struct TodoListFeature: Reducer {
  
  init() { }
  
  struct State: Equatable {
    var todos: IdentifiedArrayOf<TodoRowFeature.State>
  }
  
  enum Action: Equatable {
    case todo(id: TodoModel.ID, action: TodoRowFeature.Action)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .todo(id: id, action: .alert(.presented(.confirmDeletion))):
        state.todos.remove(id: id)
        return .none
        
      case .todo:
        return .none
      }
    }
    .forEach(\.todos, action: /Action.todo) {
      TodoRowFeature()
    }
  }
}

struct TodoListView: View {
  let store: StoreOf<TodoListFeature>
  
  var body: some View {
    List {
      ForEachStore(
        store.scope(state: \.todos, action: TodoListFeature.Action.todo)
      ) { store in
        TodoRowView(store: store)
      }
    }
  }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      TodoListView(
        store: .init(
          initialState: .init(todos: .mocks),
          reducer: TodoListFeature()
        )
      )
    }
  }
}
