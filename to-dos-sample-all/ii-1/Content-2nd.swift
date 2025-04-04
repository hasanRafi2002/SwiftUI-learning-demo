
import SwiftUI

struct SecondView: View {
    var body: some View {
        
        VStack{
            Text("This is the second screen! 🎉☢︎")
                .font(.title3)
                .foregroundColor(.blue)
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .fontWeight(.bold)
            
            
            NavigationLink("Go Back", destination: ContentView())
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .fontWeight(.bold)
            
            
            
                
                
        }
        .navigationTitle("Second screen")
        
    }
}


#Preview {
    SecondView()
}
