import ComposableArchitecture
import SwiftUI

struct TodoListFeature: Reducer {
  
  init() { }
  
  struct State: Equatable {
    var todos: IdentifiedArrayOf<TodoRowFeature.State>
		@PresentationState var alert: AlertState<Action.Alert>?
		var deletingId: TodoModel.ID?
  }
  
  enum Action: Equatable {
    case todo(id: TodoModel.ID, action: TodoRowFeature.Action)
		case alert(PresentationAction<Alert>)

		enum Alert: Equatable {
			case confirmDeletion
		}
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
			case let .todo(id: id, action: .deleteButtonTapped):
				state.alert = .delete()
				state.deletingId = id
        return .none

			case .alert(.presented(.confirmDeletion)):
				guard let id = state.deletingId else {
					return .none
				}
				state.todos.remove(id: id)
				return .none
        
      case .todo:
        return .none

			case .alert(.dismiss):
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
		.alert(store: store.scope(state: \.$alert, action: TodoListFeature.Action.alert))
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
