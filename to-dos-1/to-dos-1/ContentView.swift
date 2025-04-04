

import SwiftUI

class TaskViewModel: ObservableObject{
    @Published var tasks: [String] = ["Learn SwiftUI", "Build iOS App", "Explore UIKit", "Explore macOS"]
    
    func addTask(_ task: String){
        guard !task.isEmpty else{return}
        DispatchQueue.main.async{
            self.tasks.append(task)
        }
    }
    
        func deleteTask(at offsets: IndexSet){
            DispatchQueue.main.async{
                self.tasks.remove(atOffsets: offsets)
            }
        }
}

struct ContentView: View {
    
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTask = ""
    
    var body: some View {
        ZStack{
            
//            Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color.teal, Color.mint, Color.purple]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20){
                
//                Title
                Text("My Tasks")
                    .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                
//                Input Field with Add Button
                HStack{
                    TextField("Enter new task...", text: $newTask)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action:{
                        viewModel.addTask(newTask)
                        newTask = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                        
                    }

                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .padding(.horizontal)
                
//                Task List
                ScrollView{
                    ForEach(viewModel.tasks, id:\.self){
                        task in
                        HStack{
                            Text(task)
                                .font(.headline)
                                .foregroundColor(.brown)
                                .padding(.vertical,10)
                            Spacer()
                            
//                            Delete Button
                            Button(action:{
                                if let index = viewModel.tasks.firstIndex(of: task){
                                    viewModel.tasks.remove(at: index)
                                            }
                            }){
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            
                        }
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        
                        
                        
                    }
                    
                    .onDelete(perform: viewModel.deleteTask)
                    
                    
                }
                .listStyle(PlainListStyle())
                .cornerRadius(10)
                .padding(.top)
                
                Spacer()
                
                
            }
            .padding()
            
        }
        
    }
}

#Preview {
    ContentView()
}


