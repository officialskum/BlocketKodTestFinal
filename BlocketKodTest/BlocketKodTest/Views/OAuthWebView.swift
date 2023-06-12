import SwiftUI
import WebKit

struct OAuthWebView: UIViewRepresentable {
    let authorizationURL: URL
    
    // Skapar upp och returnerar en Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    // Gör en request med authorizationURL:en
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: authorizationURL)
        webView.load(request)
    }
    
    // Coordinatorn kommer hantera events och navigering inuti WebVyn.
    class Coordinator: NSObject, WKNavigationDelegate {
        
        // Implementerar de nödvändiga delegatmetoderna för WKNavigationDelegate protokollet.
        // Dessa metoder kommer hantera events som page loading, redirects och error hantering.
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Handle WebView didFinish navigation event
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // Handle WebView didFail navigation event
        }
    }
}

