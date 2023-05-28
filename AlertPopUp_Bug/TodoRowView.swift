import ComposableArchitecture
import SwiftUI

struct TodoRowFeature: Reducer {
  
  struct State: Equatable, Identifiable {
    var id: TodoModel.ID { todo.id }
    var todo: TodoModel
    @PresentationState var alert: AlertState<Action.Alert>?
  }
  
  enum Action: Equatable {
    case alert(PresentationAction<Alert>)
    case deleteButtonTapped
    
    enum Alert: Equatable {
      case confirmDeletion
    }
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .alert:
        return .none
        
      case .deleteButtonTapped:
        state.alert = .delete()
        return .none
      }
    }
  }
}

extension AlertState where Action == TodoRowFeature.Action.Alert {
  static func delete() -> Self {
    .init {
      TextState("Delete Todo")
    } actions: {
      .destructive(TextState("Delete"), action: .send(.confirmDeletion, animation: .default))
    } message: {
      TextState("Are you sure you'd like to delete this todo?")
    }
  }
}

struct TodoRowView: View {
  let store: StoreOf<TodoRowFeature>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        Text(viewStore.todo.title)
        Spacer()
        Image(systemName: viewStore.todo.isCompleted ? "checkmark.square" : "square")
      }
      .alert(store: store.scope(state: \.$alert, action: TodoRowFeature.Action.alert))
      .swipeActions(edge: .trailing, allowsFullSwipe: false) {
        Button(role: .destructive) {
          viewStore.send(.deleteButtonTapped)
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
      .contextMenu {
        Button(role: .destructive) {
          viewStore.send(.deleteButtonTapped)
        } label: {
          Label("Delete", systemImage: "trash")
        }
      }
    }
  }
}

//struct TodoRowView_Previews: PreviewProvider {
//  static var previews: some View {
//    TodoRowView()
//  }
//}
