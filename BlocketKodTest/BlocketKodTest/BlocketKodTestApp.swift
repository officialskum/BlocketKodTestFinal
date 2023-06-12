import SwiftUI

@main
struct BlocketKodTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    if url.scheme == "blocketkodtest" {
                        DispatchQueue.global(qos: .background).async {
                            Singleton.oauth2.handleRedirectURL(url)
                        }
                    }
             }
        }
    }
}
