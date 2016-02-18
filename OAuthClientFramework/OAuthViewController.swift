////
//  OAuthWebViewController.swift
//  OAuthClient
//
//  Created by Dario Lencina on 2/6/16.
//  Copyright © 2016 BlackFireApps. All rights reserved.
//

import UIKit
import WebKit

class OAuthViewController : UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    var result : ((OAuthLoginData?, NSError?) -> Void)?
    
    @IBOutlet weak var progress: UIProgressView!
    
    var url : NSURL?
    
    var webView : WKWebView?
    
    func activeSessionCookie() -> NSHTTPCookie? {
        if let url = self.url {
            return NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(url)?.first
        }else {
            return nil
        }
    }
    
    func setCookie(cookieString : String, domain : String) {
        let cookieComponents = cookieString.componentsSeparatedByString(cookiePrefix())
        
        if let cookieValue = cookieComponents.last,
            let cookie = NSHTTPCookie(properties: [NSHTTPCookiePath : "/",NSHTTPCookieName:cookieName,NSHTTPCookieValue:cookieValue, NSHTTPCookieDomain:domain]) {
            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let result = self.result {
            result(nil, NSError(domain: "User did not login", code: 0, userInfo: nil))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let theConfig = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.view.frame, configuration:  theConfig)
        if let webView = self.webView {
            self.view.addSubview(webView)
            webView.loadRequest(NSURLRequest(URL: self.url!))
            webView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraints(webViewConstrains(webView))
            webView.navigationDelegate = self
            webView.UIDelegate = self
            webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
            self.view.bringSubviewToFront(progress)
        }
        print("\(self.activeSessionCookie())")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if let webView = object as? WKWebView {
            if (keyPath == "estimatedProgress") {
                progress.hidden = webView.estimatedProgress == 1
                progress.setProgress(Float(webView.estimatedProgress), animated: true)
            }
        }
    }
    
    func webViewConstrains(webView : WKWebView) -> [NSLayoutConstraint] {
        return [NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: webView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: webView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0),
        NSLayoutConstraint(item: webView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0)]
    }
    
    func cookiePrefix() -> String {
        return "/\(cookieName)="
    }
    
    let cookieName = "PLAY_SESSION"
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request.URL,
            let path = url.path {
            if (path.hasPrefix(self.cookiePrefix())) {
                webView.evaluateJavaScript("window.me") { [unowned self](optionalLogin, error) -> Void in
                    if  let jsonDict = optionalLogin,
                        let result = self.result,
                        let username = jsonDict["username"] as? String {
                            self.setCookie(path, domain:url.host!);
                            result(OAuthLoginData(username: username, cookie: path), nil)
                    } else {
                        if let result = self.result {
                            result(nil, NSError(domain: "unable to parse result", code: 0, userInfo: nil))
                        }
                    }
                    decisionHandler(.Cancel)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                decisionHandler(.Allow)
            }
        } else {
            decisionHandler(.Allow)
        }
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action) in
            webView.loadRequest(NSURLRequest(URL: self.url!))
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    deinit {
        if let webView = self.webView {
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }

}
