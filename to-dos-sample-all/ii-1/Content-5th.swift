import SwiftUI

struct ContentView5: View {
    @State private var posts: [Post] = [] // Store API data

    var body: some View {
        NavigationStack {
            List(posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .navigationTitle("API Posts")
            .onAppear {
                fetchPosts()
            }
        }
    }

    // Fetch posts from API
    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedPosts = try? JSONDecoder().decode([Post].self, from: data) {
                    DispatchQueue.main.async {
                        self.posts = decodedPosts // Update UI on main thread
                    }
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView5()
}
