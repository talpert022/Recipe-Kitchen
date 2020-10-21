//
//  RecipeViewController.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 9/3/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import UIKit
import WebKit

class RecipeViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        spinner.startAnimating()
        spinner.isHidden = false
        spinner.hidesWhenStopped = true
        
        let url_ = URL(string: url)
        webView.load(URLRequest(url: url_!))
    }
/*
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        view = webView
    }
    */
    func showActivityIndicator(show: Bool) {
        if show {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    
}
