//
//  OAuthClient.swift
//  OAuthClient
//
//  Created by Dario Lencina on 2/6/16.
//  Copyright © 2016 BlackFireApps. All rights reserved.
//

import Foundation

public struct OAuthLoginResult {
    let username : String
    let token : String
    let refreshToken : String
    
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
    
    public class func login(context: UIViewController, result : (OAuthLoginResult) -> Void) -> Void {
        let bundle = NSBundle(forClass:OAuthViewController.self)
        let storyBoard : UIStoryboard = UIStoryboard(name: "OAuthStoryboard", bundle: bundle)
        let navController : UINavigationController = storyBoard.instantiateInitialViewController()! as! UINavigationController
        let rootViewController = navController.viewControllers.first as! OAuthViewController
        rootViewController.result = result
        context.presentViewController(navController, animated: true, completion: nil)
    }
    
    public class func logout(result : (Bool) -> Void) -> Void {
        result(true)
    }
    
}