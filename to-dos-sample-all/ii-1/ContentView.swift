


import SwiftUI



struct ContentView: View {
    
    @State private var message = "Hello Tawhid! welcome to my app 🚀"
    
    
    var body: some View {
        
        
        NavigationStack{
            
        

        VStack{
            Text(message)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()
            Button("Click me"){
                message = "You clicked the button! 💥"
                
            }
            .padding()
            .background(Color.cyan)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .cornerRadius(20)

     
            NavigationLink("go back", destination: SecondView())
                .padding()
                .background(Color.purple)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .cornerRadius(20)
            
            
            
        }
            
            .navigationBarTitle("Home")
        }
        }
    
    
    
        
}

#Preview {
    ContentView()
}

