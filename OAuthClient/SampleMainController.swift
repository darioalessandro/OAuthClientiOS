//
//  SampleMainController.swift
//  OAuthClient
//
//  Created by Dario Lencina on 2/6/16.
//  Copyright © 2016 BlackFireApps. All rights reserved.
//

import UIKit
import OAuthClientFramework

class SampleMainController: UITableViewController {
    
    @IBOutlet weak var connectedAs: UITableViewCell!
    @IBOutlet weak var login: UITableViewCell!
    @IBOutlet weak var logout: UITableViewCell!

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if(cell == connectedAs) {
            
        } else if(cell == login) {
            OAuthClient.login(self, result : self.loginResult)
        } else if(cell == logout) {
            OAuthClient.logout(self.logoutResult)
        }
    }
    
    var loginResult : (OAuthLoginResult) -> Void = {(result : OAuthLoginResult) in
        
    }
    
    var logoutResult : (Bool) -> Void = {(result : Bool) in
        
    }
}
