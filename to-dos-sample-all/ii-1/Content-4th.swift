import SwiftUI

class TaskViewModel4: ObservableObject {
    @Published var tasks: [String] = ["Learn SwiftUI", "Build iOS App", "Explore Navigation", "Use Lists", "Fetch API Data"]
}

struct ContentView4: View {
    
    @StateObject private var viewModel = TaskViewModel4()
    @State private var newTask = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter new task", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fontWeight(.bold)
                    .padding()
                
                Button(action: addTask) {
                    Text("Add Task")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                
                List {
                    ForEach(viewModel.tasks, id: \.self) { task in
                        Text(task)
                    }
                    .onDelete(perform: deleteTask)
                }
                .toolbar {
                    EditButton()
                }
            }
            .navigationTitle("My To-Dos")
            .padding()
        }
    }
    
    private func addTask() {
        guard !newTask.isEmpty else { return }
        viewModel.tasks.append(newTask)
        newTask = ""
    }
    
    private func deleteTask(at offsets: IndexSet) {
        viewModel.tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView4()
}
