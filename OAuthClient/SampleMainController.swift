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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectedAs.hidden = true
        self.logout.hidden = true
        self.login.hidden = false
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        if(cell == connectedAs) {
            
        } else if(cell == login) {
            OAuthClient.sharedInstance.login(self, result : self.loginResult)
        } else if(cell == logout) {
            OAuthClient.sharedInstance.logout(self.logoutResult)
        }
    }
    
    lazy var loginResult : (OAuthLoginData?, NSError?) -> Void = {[unowned self](data : OAuthLoginData?, error : NSError?) in
        if let loginData = data {
            self.connectedAs.hidden = false
            self.logout.hidden = false
            self.login.hidden = true
            self.connectedAs.detailTextLabel!.text = loginData.username
        } else {
            self.connectedAs.hidden = true
            self.logout.hidden = true
            self.login.hidden = false
        }
    }
    
    lazy var logoutResult : (Bool) -> Void = {[unowned self](result : Bool) in
        self.connectedAs.hidden = true
        self.logout.hidden = true
        self.login.hidden = false
    }
}
