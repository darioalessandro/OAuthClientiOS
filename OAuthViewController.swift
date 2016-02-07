//
//  OAuthWebViewController.swift
//  OAuthClient
//
//  Created by Dario Lencina on 2/6/16.
//  Copyright © 2016 BlackFireApps. All rights reserved.
//

import UIKit
import WebKit

class OAuthViewController : UIViewController, WKNavigationDelegate {
    
    var result : ((OAuthLoginData?, NSError?) -> Void)?
    
    @IBOutlet weak var progress: UIProgressView!
    
    let url = "http://192.168.1.73:9000?client_id=1&scope=/asdfsdf"
    
    var webView : WKWebView?
    
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
            webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
            webView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraints(webViewConstrains(webView))
            webView.navigationDelegate = self
            webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
            self.view.bringSubviewToFront(progress)
            self.performSelector(Selector("pollCredentials:"), withObject: webView, afterDelay: 1)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
    }
    
    func pollCredentials(webView : WKWebView) {
        webView.evaluateJavaScript("window.loginData") { (optionalLogin, error) -> Void in
            if let jsonDict = optionalLogin,
               let result = self.result,
               let username = jsonDict["username"] as? String,
               let token = jsonDict.valueForKeyPath("token.token") as? String,
               let refreshToken = jsonDict.valueForKeyPath("token.refreshToken") as? String {
                result(OAuthLoginData(username: username, token: token, refreshToken: refreshToken), nil)
               self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.performSelector(Selector("pollCredentials:"), withObject: webView, afterDelay: 1)
            }
        }
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
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: {(action) in
            webView.loadRequest(NSURLRequest(URL: NSURL(string: self.url)!))
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    deinit {
        if let webView = self.webView {
            webView.removeObserver(self, forKeyPath: "estimatedProgress")
        }
    }

}
