//
//  WebView.swift
//  NewsReader
//
//  Created by Asem on 31/07/2023.
//
import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    let url: URL?
    func makeUIView(context: Context) -> WKWebView {return WKWebView()}
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url ?? URL(string: "https://www.google.com/")!)
        webView.load(request)
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(url: nil)
    }
}
