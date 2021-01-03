//
//  LogInController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 28.12.2020.
//

import UIKit
import WebKit

class LogInController: UIViewController {

    //MARK: Properties
    var webview = WKWebView()

    //MARK: Lifestyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpNavTabBars()
        webViewSetup()
        loginRequest()
    }

    //MARK: Helpers

    func webViewSetup() {
        view.addSubview(webview)
        webview.addConstraintsToFillView(view)
        webview.navigationDelegate = self
        webview.backgroundColor = .black
    }

    //MARK: API
    func loginRequest () {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7717352"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value:
            "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.126")
        ]
        guard let componentsUrl = urlComponents.url else {
            return
        }
        let request = URLRequest(url: componentsUrl)
        webview.load(request)
    }

}

extension LogInController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse:
            WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy)
    -> Void) {
        guard let url = navigationResponse.response.url, url.path ==
                "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
                .components(separatedBy: "&")
                .map {
                    $0.components(separatedBy: "=")
                }
                .reduce([String: String]()) { result, param in
                    var dict = result
                    let key = param[0]
                    let value = param[1]
                    dict[key] = value
                    return dict
                }
        Session.instance.token = params["access_token"]
        Session.instance.userId = Int(params["user_id"] ?? "0")

        decisionHandler(.cancel)
        DispatchQueue.main.async {
            let main = MainTabControllerViewController()
            main.modalPresentationStyle = .fullScreen
            self.present(main, animated: true)
        }
    }
}
