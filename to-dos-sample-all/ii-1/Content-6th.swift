import SwiftUI

// ViewModel to manage tasks
class TaskViewModel1: ObservableObject {
    @Published var tasks: [String] = ["Learn SwiftUI", "Build iOS App", "Explore Navigation"]
    
    func addTask(_ task: String) {
        guard !task.isEmpty else { return }
        tasks.append(task)
    }
    
    func deleteTask(at index: Int) {
        tasks.remove(at: index)
    }
}

struct StyledToDoView: View {
    @StateObject private var viewModel = TaskViewModel1()
    @State private var newTask = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("📌 My Tasks")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Input Field
                HStack {
                    TextField("Enter new task...", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        viewModel.addTask(newTask)
                        newTask = "" // Clear input after adding
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(15)
                
                // Task List
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.tasks.indices, id: \.self) { index in
                            HStack {
                                Text(viewModel.tasks[index])
                                    .font(.headline)
                                    .padding()
                                
                                Spacer()
                                
                                // Delete Button
                                Button(action: {
                                    withAnimation {
                                        viewModel.deleteTask(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                        .padding()
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    StyledToDoView()
}
