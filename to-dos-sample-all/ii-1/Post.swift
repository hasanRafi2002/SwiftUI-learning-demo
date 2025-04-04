import Foundation

// Model for a Post
struct Post: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
}
