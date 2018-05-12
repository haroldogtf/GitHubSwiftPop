//
//  PullRequestDetailViewController.swift
//  DesafioConcrete
//
//  Created by Haroldo Gondim on 26/01/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import PKHUD
import UIKit
import WebKit

class PullRequestDetailViewController: UIViewController {

    var repositoryName:String!
    var url:String!

    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
    }
    
    func loadWebView() {
        webView = WKWebView()
        webView.navigationDelegate = self

        HUD.show(.progress)
        let urlRequest = URL(string: url)!
        webView.load(URLRequest(url: urlRequest))
        
        view = webView
    }

}

extension PullRequestDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hide(animated: true)
    }
    
}
