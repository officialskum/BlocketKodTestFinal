import Foundation
import OAuth2

enum Singleton {
    static let oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "cee7effc1d936aff852b",
        "client_secret": "65a2ec3b1638db479604ed3e72966d05e0511de2",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "redirect_uris": ["blocketkodtest://callback"],
        "scope": "user repo:status",
        "secret_in_body": true,
        "keychain": false,
    ] as OAuth2JSON)
}

enum LoadingState {
    case idle
    case loading
    case successful
}

enum LoginProvider {
    case github
    case gmail
    case facebook
    case apple
}

enum loginAlternatives: String {
    case fetchRepos = "Fetch Repos"
    case login = "Login"
}

//extension URL {
//    var queryParameters: [String: String]? {
//        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
//              let queryItems = components.queryItems else {
//            return nil
//        }
//
//        var parameters: [String: String] = [:]
//        queryItems.forEach { item in
//            parameters[item.name] = item.value
//        }
//
//        return parameters
//    }
//}

