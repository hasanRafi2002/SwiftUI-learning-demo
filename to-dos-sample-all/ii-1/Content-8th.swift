//import SwiftUI
//
//struct Task1: Identifiable, Codable {
//    var id = UUID()
//    var title: String
//    var isCompleted: Bool = false
//    var priority: Priority = .normal
//    var dueDate: Date?
//    
//    enum Priority: String, Codable, CaseIterable {
//        case low = "Low"
//        case normal = "Normal"
//        case high = "High"
//    }
//}
//
//struct ContentView8: View {
//    
//    @State private var tasks: [Task1] = [
//        Task1(title: "Learn SwiftUI", priority: .high),
//        Task1(title: "Build iOS App", priority: .high),
//        Task1(title: "Explore Navigation", priority: .normal),
//        Task1(title: "Use Lists", priority: .normal),
//        Task1(title: "Fetch API Data", priority: .low)
//    ]
//    @State private var newTask = ""
//    @State private var selectedPriority: Task.Priority = .normal
//    @State private var showCompletedTasks = true
//    @State private var searchText = ""
//    @State private var showAddTaskView = false
//    
//    var filteredTasks: [Task1] {
//        var filtered = tasks
//        
//        // Filter by completion status
//        if !showCompletedTasks {
//            filtered = filtered.filter { !$0.isCompleted }
//        }
//        
//        // Filter by search text
//        if !searchText.isEmpty {
//            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
//        }
//        
//        return filtered
//    }
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                searchBar
//                
//                taskList
//                
//                addTaskButton
//            }
//            .sheet(isPresented: $showAddTaskView) {
//                AddTaskView(tasks: $tasks, isPresented: $showAddTaskView)
//            }
//            .navigationTitle("My Tasks")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Menu {
//                        Toggle("Show Completed", isOn: $showCompletedTasks)
//                        Divider()
//                        Text("Sort by")
//                        Button("Priority") {
//                            tasks.sort { $0.priority.rawValue > $1.priority.rawValue }
//                        }
//                        Button("Alphabetical") {
//                            tasks.sort { $0.title < $1.title }
//                        }
//                    } label: {
//                        Label("Filter", systemImage: "slider.horizontal.3")
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//            }
//            .onAppear {
//                loadTasks()
//            }
//        }
//    }
//    
//    var searchBar: some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.gray)
//            
//            TextField("Search tasks", text: $searchText)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//        }
//        .padding(.horizontal)
//    }
//    
//    var taskList: some View {
//        List {
//            ForEach(filteredTasks) { task in
//                TaskRow(task: task, updateTask: { updatedTask in
//                    if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
//                        tasks[index] = updatedTask
//                        saveTasks()
//                    }
//                })
//            }
//            .onDelete(perform: deleteTask)
//            .onMove(perform: moveTask)
//        }
//    }
//    
//    var addTaskButton: some View {
//        Button(action: {
//            showAddTaskView = true
//        }) {
//            HStack {
//                Image(systemName: "plus.circle.fill")
//                Text("Add New Task")
//                    .fontWeight(.semibold)
//            }
//            .foregroundColor(.white)
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
//            .cornerRadius(12)
//            .shadow(radius: 3)
//            .padding()
//        }
//    }
//    
//    func deleteTask(at offsets: IndexSet) {
//        tasks.remove(atOffsets: offsets)
//        saveTasks()
//    }
//    
//    func moveTask(from source: IndexSet, to destination: Int) {
//        tasks.move(fromOffsets: source, toOffset: destination)
//        saveTasks()
//    }
//    
//    func saveTasks() {
//        if let encoded = try? JSONEncoder().encode(tasks) {
//            UserDefaults.standard.set(encoded, forKey: "savedTasks")
//        }
//    }
//    
//    func loadTasks() {
//        if let savedTasks = UserDefaults.standard.data(forKey: "savedTasks") {
//            if let decodedTasks = try? JSONDecoder().decode([Task].self, from: savedTasks) {
//                tasks = decodedTasks
//                return
//            }
//        }
//    }
//}
//
//struct TaskRow: View {
//    var task: Task
//    var updateTask: (Task) -> Void
//    
//    var body: some View {
//        HStack {
//            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
//                .foregroundColor(task.isCompleted ? .green : priorityColor(task.priority))
//                .onTapGesture {
//                    var updatedTask = task
//                    updatedTask.isCompleted.toggle()
//                    updateTask(updatedTask)
//                }
//            
//            VStack(alignment: .leading) {
//                Text(task.title)
//                    .font(.system(size: 16, weight: .medium))
//                    .strikethrough(task.isCompleted)
//                
//                if let dueDate = task.dueDate {
//                    Text("Due: \(formattedDate(dueDate))")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//            }
//            
//            Spacer()
//            
//            Text(task.priority.rawValue)
//                .font(.caption)
//                .foregroundColor(.white)
//                .padding(.horizontal, 8)
//                .padding(.vertical, 4)
//                .background(priorityColor(task.priority))
//                .cornerRadius(8)
//        }
//        .padding(.vertical, 6)
//    }
//    
//    func priorityColor(_ priority: Task.Priority) -> Color {
//        switch priority {
//        case .low:
//            return .blue
//        case .normal:
//            return .orange
//        case .high:
//            return .red
//        }
//    }
//    
//    func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        return formatter.string(from: date)
//    }
//}
//
//struct AddTaskView: View {
//    @Binding var tasks: [Task]
//    @Binding var isPresented: Bool
//    
//    @State private var taskTitle = ""
//    @State private var selectedPriority: Task.Priority = .normal
//    @State private var dueDate = Date()
//    @State private var includeDueDate = false
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section(header: Text("Task Details")) {
//                    TextField("Task name", text: $taskTitle)
//                    
//                    Picker("Priority", selection: $selectedPriority) {
//                        ForEach(Task.Priority.allCases, id: \.self) { priority in
//                            Text(priority.rawValue).tag(priority)
//                        }
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                }
//                
//                Section {
//                    Toggle("Set due date", isOn: $includeDueDate)
//                    
//                    if includeDueDate {
//                        DatePicker("Due date", selection: $dueDate, displayedComponents: .date)
//                    }
//                }
//            }
//            .navigationTitle("Add New Task")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        isPresented = false
//                    }
//                }
//                
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Save") {
//                        if !taskTitle.isEmpty {
//                            let newTask = Task(
//                                title: taskTitle,
//                                priority: selectedPriority,
//                                dueDate: includeDueDate ? dueDate : nil
//                            )
//                            tasks.append(newTask)
//                            
//                            if let encoded = try? JSONEncoder().encode(tasks) {
//                                UserDefaults.standard.set(encoded, forKey: "savedTasks")
//                            }
//                            
//                            isPresented = false
//                        }
//                    }
//                    .disabled(taskTitle.isEmpty)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView8()
//}
