//
//  ScriptureViewController.swift
//  Map Scriptures
//
//  Created by Peter West on 10/24/16.
//  Copyright © 2016 Peter West. All rights reserved.
//

import UIKit
import WebKit

class ScriptureViewController : UIViewController, WKNavigationDelegate {
    
    //Mark: - Properties
    var book: Book!
    var chapter = 0
    
    private var webView: WKWebView!
    
    override func loadView() {
        let webViewConfiguration = WKWebViewConfiguration()
        
        webViewConfiguration.preferences.javaScriptEnabled = false
        
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let html = ScriptureRenderer.sharedRenderer.htmlForBookId(book.id, chapter: chapter)
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    
}


