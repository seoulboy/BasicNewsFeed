//
//  WebViewController.swift
//  NewsAPIFeed
//
//  Created by Imho Jang on 3/15/25.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize WKWebView
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView  // Set webView as the main view

        // Load the URL
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
