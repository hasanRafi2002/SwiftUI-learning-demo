//import SwiftUI
//
//// Activity Model
//struct Activity: Identifiable, Hashable {
//    let id = UUID()
//    var name: String
//    var isDone: Bool = false
//    var group: ActivityGroup
//    var importance: ActivityImportance
//    
//    enum ActivityImportance: String, CaseIterable {
//        case minor = "Minor"
//        case normal = "Normal"
//        case urgent = "Urgent"
//        
//        var shade: Color { [.cyan, .yellow, .pink][rawValue == "Minor" ? 0 : rawValue == "Normal" ? 1 : 2] }
//        var symbol: String { ["circle.fill", "triangle.fill", "exclamationmark.triangle.fill"][rawValue == "Minor" ? 0 : rawValue == "Normal" ? 1 : 2] }
//    }
//}
//
//// Activity Group
//struct ActivityGroup: Identifiable, Hashable {
//    let id = UUID()
//    var title: String
//    var hue: Color
//    
//    static let presets: [ActivityGroup] = [
//        ActivityGroup(title: "Daily", hue: .indigo),
//        ActivityGroup(title: "Career", hue: .teal),
//        ActivityGroup(title: "Fitness", hue: .mint)
//    ]
//}
//
//// Manager
//class ActivityManager: ObservableObject {
//    @Published var activities: [Activity] = []
//    @Published var groups: [ActivityGroup] = ActivityGroup.presets
//    
//    init() {
//        activities = [
//            Activity(name: "Master SwiftUI", group: groups[1], importance: .urgent),
//            Activity(name: "Morning Yoga", group: groups[2], importance: .minor),
//            Activity(name: "Get Supplies", group: groups[0], importance: .normal)
//        ]
//    }
//    
//    func insertActivity(_ activity: Activity) { withAnimation { activities.append(activity) } }
//    func eraseActivity(activity: Activity) { withAnimation { activities.removeAll { $0.id == activity.id } } }
//    func switchStatus(for activity: Activity) {
//        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
//            withAnimation { activities[index].isDone.toggle() }
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
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                TextField("Activity Name", text: $activityName)
//                Picker("Group", selection: $chosenGroup) {
//                    ForEach(manager.groups) { group in
//                        Text(group.title).tag(group as ActivityGroup?)
//                    }
//                }
//                Picker("Importance", selection: $significance) {
//                    ForEach(Activity.ActivityImportance.allCases, id: \.self) { level in
//                        Text(level.rawValue).tag(level)
//                    }
//                }
//                Button("Create") {
//                    guard let group = chosenGroup, !activityName.isEmpty else { return }
//                    manager.insertActivity(Activity(name: activityName, group: group, importance: significance))
//                    close()
//                }
//                .disabled(activityName.isEmpty || chosenGroup == nil)
//            }
//            .navigationTitle("Add Activity")
//            .toolbar { Button("Close") { close() } }
//            .onAppear { chosenGroup = manager.groups.first }
//        }
//    }
//}
//
//// Main View
//struct ActivityHubView: View {
//    @StateObject private var manager = ActivityManager()
//    @State private var showNewActivity = false
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                Color(hex: "2A2A72").ignoresSafeArea()
//                
//                ScrollView {
//                    LazyVStack(spacing: 12) {
//                        ForEach(manager.activities) { activity in
//                            ActivityItem(activity: activity, manager: manager)
//                        }
//                        Button(action: { showNewActivity = true }) {
//                            Label("New Activity", systemImage: "plus")
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color(hex: "009FFD"))
//                                .foregroundColor(.white)
//                                .clipShape(Capsule())
//                        }
//                    }
//                    .padding()
//                }
//            }
//            .navigationTitle("Activity Hub")
//            .toolbar {
//                Button(action: { showNewActivity = true }) {
//                    Image(systemName: "plus").foregroundColor(.white)
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
//    @State private var shift: CGFloat = 0
//    @State private var showDeleteConfirmation = false
//    
//    var body: some View {
//        ZStack {
//            // Delete background
//            HStack {
//                Spacer()
//                Color.red
//                    .frame(width: 80)
//            }
//            
//            // Main content
//            HStack(spacing: 12) {
//                Button(action: { manager.switchStatus(for: activity) }) {
//                    Image(systemName: activity.isDone ? "checkmark.square.fill" : "square")
//                        .foregroundColor(activity.isDone ? activity.group.hue : .gray)
//                }
//                Text(activity.name)
//                    .strikethrough(activity.isDone)
//                    .foregroundColor(activity.isDone ? .gray : .white)
//                Spacer()
//                Image(systemName: activity.importance.symbol)
//                    .foregroundColor(activity.importance.shade)
//                Button(action: { showDeleteConfirmation = true }) {
//                    Image(systemName: "trash")
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//            .offset(x: shift)
//            .gesture(
//                DragGesture()
//                    .onChanged { value in shift = max(value.translation.width, -80) }
//                    .onEnded { value in
//                        withAnimation {
//                            if value.translation.width < -40 {
//                                showDeleteConfirmation = true
//                                shift = 0
//                            } else {
//                                shift = 0
//                            }
//                        }
//                    }
//            )
//            .alert("Delete Activity", isPresented: $showDeleteConfirmation) {
//                Button("Cancel", role: .cancel) { }
//                Button("Delete", role: .destructive) {
//                    manager.eraseActivity(activity: activity)
//                }
//            } message: {
//                Text("Are you sure you want to delete \"\(activity.name)\"?")
//            }
//        }
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
//#Preview {
//    ActivityHubView()
//}
