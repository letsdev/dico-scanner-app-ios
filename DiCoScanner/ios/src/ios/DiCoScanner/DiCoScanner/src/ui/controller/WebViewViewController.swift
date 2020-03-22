//
//  WebViewViewController.swift
//  DiCoScanner
//
//  Created by Sebastian Ruf on 22.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func loadUrl(urlString: String?) {
        guard let url = urlString else {
            return
        }
        loadUrl(url: URL(string: url))
    }

    func loadUrl(url: URL?) {
        guard let createdUrl = url else {
            return
        }
        let urlRequest = URLRequest(url: createdUrl)
        if isViewLoaded {
            webView.load(urlRequest)
        } else {
        }
    }

    func loadHtml(htmlContent: String?, baseUrl: URL? = nil) {
        guard let content = htmlContent else {
            return
        }
        webView.loadHTMLString(content, baseURL: baseUrl)
    }

    func reload() {
        webView.reload()
    }
}
