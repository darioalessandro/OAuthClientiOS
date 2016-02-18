//
//  OAuthClient.swift
//  OAuthClient
//
//  Created by Dario Lencina on 2/6/16.
//  Copyright © 2016 BlackFireApps. All rights reserved.
//

import Foundation

public struct OAuthLoginData {
    public let username : String
    public let cookie : String
    
    init(username : String,
        cookie : String) {
            self.username = username
            self.cookie = cookie
    }
}

/**
 Class used to perform OAuth client flow.
 
 Configuration should be passed via app plist
 
 Create a dictionary like this
 
 OAuthConfig
    -> client_id        (String)
    -> scope            (String)
    -> url              (String with url including path)
*/

public class OAuthClient : NSObject {
    
    /**
     Method to kick off the login process
    */
    
    public static let sharedInstance = OAuthClient()
    
    override private init() {
        super.init()
    }
    
    public var loginData : OAuthLoginData?
    
    public func login(context: UIViewController, result : (OAuthLoginData?, NSError?) -> Void) -> Void {
        let bundle = NSBundle(forClass:OAuthViewController.self)
        let storyBoard : UIStoryboard = UIStoryboard(name: "OAuthStoryboard", bundle: bundle)
        let navController : UINavigationController = storyBoard.instantiateInitialViewController()! as! UINavigationController
        let rootViewController = navController.viewControllers.first as! OAuthViewController
        rootViewController.result = {(res : OAuthLoginData?, error : NSError?) in
            self.loginData = res
            result(res,error)
        }
        
        let oAuthConfig = OAuthConfig()
        
        //rootViewController.url = NSURL(string: "\(oAuthConfig["url"]!)?client_id=\(oAuthConfig["client_id"]!)&scope=\(oAuthConfig["scope"]!)")!
        
        rootViewController.url = NSURL(string: "\(oAuthConfig["url"]!)")!
        
        context.presentViewController(navController, animated: true, completion: nil)
    }
    
    /**
     If this does not work, we want it to blow up, but it would be nice if it could show the reason.
    */
    
    public func OAuthConfig() -> NSDictionary {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("OAuthConfig") as! NSDictionary
    }
    
    public func logout(result : (Bool) -> Void) -> Void {
        self.loginData = nil
        result(true)
    }
    
}