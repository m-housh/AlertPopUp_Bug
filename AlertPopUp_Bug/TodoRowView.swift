import ComposableArchitecture
import SwiftUI

struct TodoRowFeature: Reducer {
  
  struct State: Equatable, Identifiable {
    var id: TodoModel.ID { todo.id }
    var todo: TodoModel
  }
  
  enum Action: Equatable {
    case deleteButtonTapped
  }
  
  var body: some ReducerOf<Self> {
    EmptyReducer()
  }
}

extension AlertState where Action == TodoListFeature.Action.Alert {
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
		WithViewStore(store, observe: \.todo) { viewStore in
      HStack {
        Text(viewStore.title)
        Spacer()
        Image(systemName: viewStore.isCompleted ? "checkmark.square" : "square")
      }
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
