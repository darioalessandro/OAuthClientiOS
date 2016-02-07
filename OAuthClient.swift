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
    public let token : String
    public let refreshToken : String
    
    init(username : String,
        token : String,
        refreshToken : String) {
            self.username = username
            self.token = token
            self.refreshToken = refreshToken
    }
}

/**
 Class used to perform OAuth client flow.
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
        
        context.presentViewController(navController, animated: true, completion: nil)
    }
    
    public func logout(result : (Bool) -> Void) -> Void {
        self.loginData = nil
        result(true)
    }
    
}