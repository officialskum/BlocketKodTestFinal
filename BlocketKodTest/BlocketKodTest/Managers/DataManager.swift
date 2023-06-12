import Foundation
import OAuth2
import SwiftUI

protocol DataManagerProtocol {
    func authorizeWithOAuth() -> Void
    func fetchRepositories() -> Void
    func logout() -> Void 
}

class DataManager: DataManagerProtocol, ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var repositories: [Repository] = []
    var authenticatedUser: String
    
    static let shared = DataManager()
    
    internal init(
        authenticatedUser: String = ""
    ) {
        Singleton.oauth2.logger = OAuth2DebugLogger(.trace)
        self.authenticatedUser = authenticatedUser
    }
    
    func authorizeWithOAuth() {
        guard loadingState == .idle else {
            return
        }
        
        loadingState = .loading
        
        let base = URL(string: "https://api.github.com")!
        let url = base.appendingPathComponent("user")
        
        var req = Singleton.oauth2.request(forURL: url)
        req.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let loader = OAuth2DataLoader(oauth2: Singleton.oauth2)
        loader.perform(request: req) { response in
            do {
                let dict = try response.responseJSON()
                
                if let user = dict["login"] as? String {
                    DispatchQueue.main.async {
                        self.authenticatedUser = user
                        self.fetchRepositories()
                    }
                }
            }
            catch let error {
                print("Error occured: \(error)")
            }
        }
    }
    
    func fetchRepositories() {
        loadingState = .loading
        
        guard let accessToken = Singleton.oauth2.accessToken else {
            print("Access token not available")
            return
        }
        
        guard let url = URL(string: "https://api.github.com/users/\(authenticatedUser)/repos") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let repositories = try JSONDecoder().decode([Repository].self, from: data)
                    DispatchQueue.main.async {
                        self.repositories = repositories
                        self.loadingState = .successful
                    }
                } catch {
                    print("Error decoding repositories: \(error as? DecodingError)")
                }
            }
        }
            task.resume()
    }
    
    func logout() {
        loadingState = .loading
        
        Singleton.oauth2.accessToken = nil
        self.authenticatedUser = ""
        self.repositories = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadingState = .idle
        }
    }
}
