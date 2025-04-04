//import SwiftUI
//
//// Activity Model
//struct Activity: Identifiable, Hashable {
//    let id = UUID()
//    var name: String
//    var isDone: Bool = false
//    var group: ActivityGroup
//    var importance: ActivityImportance
//    var dueDate: Date?
//    var notes: String?
//    
//    enum ActivityImportance: String, CaseIterable {
//        case minor = "Minor"
//        case normal = "Normal"
//        case urgent = "Urgent"
//        
//        var shade: Color { [.cyan.opacity(0.7), .yellow.opacity(0.7), .pink.opacity(0.7)][rawValue == "Minor" ? 0 : rawValue == "Normal" ? 1 : 2] }
//        var symbol: String { ["circle.fill", "triangle.fill", "exclamationmark.triangle.fill"][rawValue == "Minor" ? 0 : rawValue == "Normal" ? 1 : 2] }
//    }
//}
//
//// Activity Group
//struct ActivityGroup: Identifiable, Hashable {
//    let id = UUID()
//    var title: String
//    var hue: Color
//    var icon: String
//    
//    static let presets: [ActivityGroup] = [
//        ActivityGroup(title: "Daily", hue: .indigo, icon: "sun.max"),
//        ActivityGroup(title: "Career", hue: .teal, icon: "briefcase"),
//        ActivityGroup(title: "Fitness", hue: .mint, icon: "figure.walk")
//    ]
//}
//
//// Manager
//class ActivityManager: ObservableObject {
//    @Published var activities: [Activity] = []
//    @Published var groups: [ActivityGroup] = ActivityGroup.presets
//    @Published var sortBy: SortOption = .name
//    @Published var selectedActivities: Set<UUID> = []
//    
//    enum SortOption: String, CaseIterable {
//        case name = "Name"
//        case importance = "Importance"
//        case dueDate = "Due Date"
//    }
//    
//    init() {
//        activities = [
//            Activity(name: "Master SwiftUI", group: groups[1], importance: .urgent, dueDate: Date().addingTimeInterval(86400)),
//            Activity(name: "Morning Yoga", group: groups[2], importance: .minor),
//            Activity(name: "Get Supplies", group: groups[0], importance: .normal, notes: "Buy pens and notebooks")
//        ]
//    }
//    
//    func insertActivity(_ activity: Activity) { withAnimation(.spring()) { activities.append(activity) } }
//    func eraseActivity(activity: Activity) { withAnimation(.easeOut) { activities.removeAll { $0.id == activity.id } } }
//    func eraseSelectedActivities() {
//        withAnimation(.easeOut) {
//            activities.removeAll { selectedActivities.contains($0.id) }
//            selectedActivities.removeAll()
//        }
//    }
//    func switchStatus(for activity: Activity) {
//        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
//            withAnimation(.spring()) { activities[index].isDone.toggle() }
//        }
//    }
//    
//    var sortedActivities: [Activity] {
//        switch sortBy {
//        case .name: return activities.sorted { $0.name < $1.name }
//        case .importance: return activities.sorted { $0.importance.rawValue > $1.importance.rawValue }
//        case .dueDate: return activities.sorted { ($0.dueDate ?? .distantFuture) < ($1.dueDate ?? .distantFuture) }
//        }
//    }
//}
//
//// New Activity Panel
//struct NewActivityPanel: View {
//    @Environment(\.dismiss) var close
//    @ObservedObject var manager: ActivityManager
//    @State private var activityName = ""
//    @State private var chosenGroup: ActivityGroup?
//    @State private var significance: Activity.ActivityImportance = .normal
//    @State private var dueDate: Date?
//    @State private var notes = ""
//    @State private var showDatePicker = false
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                Section("Details") {
//                    TextField("Activity Name", text: $activityName)
//                    Picker("Group", selection: $chosenGroup) {
//                        ForEach(manager.groups) { group in
//                            Label(group.title, systemImage: group.icon).tag(group as ActivityGroup?)
//                        }
//                    }
//                    Picker("Importance", selection: $significance) {
//                        ForEach(Activity.ActivityImportance.allCases, id: \.self) { level in
//                            Text(level.rawValue).tag(level)
//                        }
//                    }
//                }
//                
//                Section("Schedule") {
//                    Toggle("Set Due Date", isOn: $showDatePicker.animation())
//                    if showDatePicker {
//                        DatePicker("Due Date", selection: Binding($dueDate, default: Date()), displayedComponents: [.date, .hourAndMinute])
//                    }
//                }
//                
//                Section("Notes") {
//                    TextEditor(text: $notes)
//                        .frame(height: 100)
//                }
//                
//                Button("Create") {
//                    guard let group = chosenGroup, !activityName.isEmpty else { return }
//                    let newActivity = Activity(name: activityName, group: group, importance: significance, dueDate: dueDate, notes: notes.isEmpty ? nil : notes)
//                    manager.insertActivity(newActivity)
//                    close()
//                }
//                .disabled(activityName.isEmpty || chosenGroup == nil)
//            }
//            .scrollContentBackground(.hidden)
//            .background(LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.1), .purple.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
//            .navigationTitle("Add Activity")
//            .toolbar {
//                Button("Close") { close() }
//            }
//            .onAppear { chosenGroup = manager.groups.first }
//        }
//    }
//}
//
//// Main View
//struct ActivityHubView: View {
//    @StateObject private var manager = ActivityManager()
//    @State private var showNewActivity = false
//    @State private var showFilter = false
//    @State private var isEditing = false
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                LinearGradient(gradient: Gradient(colors: [Color(hex: "2A2A72"), Color(hex: "1B1B4F")]), startPoint: .top, endPoint: .bottom)
//                    .ignoresSafeArea()
//                
//                VStack(spacing: 0) {
//                    HStack {
//                        Picker("Sort By", selection: $manager.sortBy) {
//                            ForEach(ActivityManager.SortOption.allCases, id: \.self) { option in
//                                Text(option.rawValue).tag(option)
//                            }
//                        }
//                        .pickerStyle(MenuPickerStyle())
//                        .padding(.horizontal)
//                        .background(.ultraThinMaterial)
//                        .clipShape(Capsule())
//                        
//                        Spacer()
//                        
//                        if isEditing && !manager.selectedActivities.isEmpty {
//                            Button(action: {
//                                manager.eraseSelectedActivities()
//                            }) {
//                                Text("Delete (\(manager.selectedActivities.count))")
//                                    .foregroundColor(.red)
//                            }
//                        }
//                    }
//                    .padding()
//                    
//                    ScrollView(.vertical, showsIndicators: true) {
//                        LazyVStack(spacing: 15) {
//                            ForEach(manager.sortedActivities) { activity in
//                                ActivityItem(activity: activity, manager: manager, isEditing: $isEditing)
//                                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
//                            }
//                            
//                            Button(action: { showNewActivity = true }) {
//                                Label("New Activity", systemImage: "plus")
//                                    .font(.headline)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "009FFD"), Color(hex: "00D4FF")]), startPoint: .leading, endPoint: .trailing))
//                                    .foregroundColor(.white)
//                                    .clipShape(Capsule())
//                                    .shadow(radius: 5)
//                            }
//                        }
//                        .padding(.horizontal)
//                        .padding(.bottom, 20)
//                    }
//                }
//            }
//            .navigationTitle("Activity Hub")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: { withAnimation { isEditing.toggle() } }) {
//                        Text(isEditing ? "Done" : "Edit")
//                            .foregroundColor(.white)
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: { showNewActivity = true }) {
//                        Image(systemName: "plus.circle.fill")
//                            .foregroundColor(.white)
//                            .font(.title2)
//                    }
//                }
//            }
//            .sheet(isPresented: $showNewActivity) {
//                NewActivityPanel(manager: manager)
//            }
//        }
//    }
//}
//
//// Activity Item
//struct ActivityItem: View {
//    let activity: Activity
//    @ObservedObject var manager: ActivityManager
//    @Binding var isEditing: Bool
//    @State private var shift: CGFloat = 0
//    @State private var showDeleteConfirmation = false
//    @State private var showDetails = false
//    
//    private let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        return formatter
//    }()
//    
//    var body: some View {
//        ZStack {
//            if !isEditing {
//                HStack {
//                    Spacer()
//                    LinearGradient(gradient: Gradient(colors: [.red, .pink]), startPoint: .top, endPoint: .bottom)
//                        .frame(width: 80)
//                }
//            }
//            
//            VStack(alignment: .leading, spacing: 8) {
//                HStack(spacing: 12) {
//                    if isEditing {
//                        Image(systemName: manager.selectedActivities.contains(activity.id) ? "checkmark.circle.fill" : "circle")
//                            .foregroundColor(manager.selectedActivities.contains(activity.id) ? .blue : .gray.opacity(0.7))
//                            .font(.title2)
//                            .onTapGesture {
//                                if manager.selectedActivities.contains(activity.id) {
//                                    manager.selectedActivities.remove(activity.id)
//                                } else {
//                                    manager.selectedActivities.insert(activity.id)
//                                }
//                            }
//                    } else {
//                        Button(action: { manager.switchStatus(for: activity) }) {
//                            Image(systemName: activity.isDone ? "checkmark.circle.fill" : "circle")
//                                .foregroundColor(activity.isDone ? activity.group.hue : .gray.opacity(0.7))
//                                .font(.title2)
//                        }
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text(activity.name)
//                            .font(.headline)
//                            .strikethrough(activity.isDone)
//                            .foregroundColor(activity.isDone ? .gray : .white)
//                        
//                        if let dueDate = activity.dueDate {
//                            Text(dateFormatter.string(from: dueDate))
//                                .font(.caption)
//                                .foregroundColor(.white.opacity(0.7))
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    Image(systemName: activity.importance.symbol)
//                        .foregroundColor(activity.importance.shade)
//                        .font(.title3)
//                    
//                    Image(systemName: activity.group.icon)
//                        .foregroundColor(activity.group.hue)
//                        .font(.title3)
//                }
//                
//                if showDetails, let notes = activity.notes {
//                    Text(notes)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.8))
//                        .padding(.leading, 44)
//                }
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            .clipShape(RoundedRectangle(cornerRadius: 15))
//            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
//            .offset(x: isEditing ? 0 : shift)
//            .gesture(
//                isEditing ? nil : DragGesture()
//                    .onChanged { value in shift = max(value.translation.width, -80) }
//                    .onEnded { value in
//                        withAnimation(.spring()) {
//                            if value.translation.width < -40 {
//                                showDeleteConfirmation = true
//                                shift = 0
//                            } else {
//                                shift = 0
//                            }
//                        }
//                    }
//            )
//            .onTapGesture { if !isEditing { withAnimation { showDetails.toggle() } } }
//            .alert("Delete Activity", isPresented: $showDeleteConfirmation) {
//                Button("Cancel", role: .cancel) { }
//                Button("Delete", role: .destructive) {
//                    manager.eraseActivity(activity: activity)
//                }
//            } message: {
//                Text("Are you sure you want to delete \"\(activity.name)\"?")
//            }
//        }
//        .frame(maxWidth: .infinity)
//    }
//}
//
//// Color Extension
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let (r, g, b) = (Double(int >> 16) / 255, Double(int >> 8 & 0xFF) / 255, Double(int & 0xFF) / 255)
//        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
//    }
//}
//
//// Binding Extension for Optional
//extension Binding {
//    init(_ source: Binding<Value?>, default defaultValue: Value) {
//        self.init(
//            get: { source.wrappedValue ?? defaultValue },
//            set: { source.wrappedValue = $0 }
//        )
//    }
//}
//
//#Preview {
//    ActivityHubView()
//}
