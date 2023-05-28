import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      TodoListView(
        store: .init(
          initialState: .init(todos: .mocks),
          reducer: TodoListFeature()._printChanges()
        )
      )
      .navigationTitle("Todos")
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
