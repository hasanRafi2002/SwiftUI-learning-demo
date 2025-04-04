import SwiftUI

struct ContentView3: View {
    
    @State private var tasks = ["Learn SwiftUi", "Build iOS App", "Explore Navigation","Use Lists", "Fetch API Data"]
    @State private var newTask = ""
    var body: some View {
        
        NavigationStack{
            
            VStack{
                TextField("Enter new task", text:$newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fontWeight(.bold)
                    .padding()
                
                Button("Add Task"){
                    if !newTask.isEmpty{
                        tasks.append(newTask)
                        newTask = ""
                    }
                }
                .padding()
                .background(Color.yellow)
                .cornerRadius(20)
                .fontWeight(.bold)

            
            
                List{
                    ForEach(tasks, id:\.self){task in
                Text(task)
                }
                    .onDelete(perform: deleteTask)

            }
                .toolbar{
                    EditButton()
                }
                
                
                
            }
            .navigationTitle("my-to-dos")
            .padding()
            
            
            
            
        }

    }
    
    func deleteTask(at offsets: IndexSet){
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView3()
}
