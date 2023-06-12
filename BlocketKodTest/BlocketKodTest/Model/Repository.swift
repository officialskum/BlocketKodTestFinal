import Foundation

struct Repository: Codable, Identifiable {
    let id: Int
    let name: String
    let created_at: String
    let description: String?
    let owner: Owner
    
    struct Owner: Codable {
        let login: String
        let avatar_url: String
    }
}
