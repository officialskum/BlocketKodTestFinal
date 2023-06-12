import SwiftUI
import OAuth2

struct ContentView: View {
    @State private var selectedProvider: LoginProvider?
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        switch dataManager.loadingState {
        case .idle:
            gitHubLogin
        case .loading:
            ProgressView()
        case .successful:
            RepositoryListView()
            //OAuthWebView(authorizationURL: dataManager.)
        }
    }
    
    var gitHubLogin: some View {
        VStack(spacing: 20) {
            githubImage
            
            Spacer().frame(height: 10)
            
            Button(action: {
                DataManager.shared.authorizeWithOAuth()
            }) {
                text(.login)
            }
        }
        .padding()
    }
    
    func text(_ option: loginAlternatives) -> some View {
        Text(option.rawValue)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .cornerRadius(10)
    }
    
    var githubImage: some View {
        Image("GithubIconPng")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
    }
}
