//
//  authViewController.swift
//  myProgress
//
//  Created by Danya on 10.11.16.
//  Copyright © 2016 Danya. All rights reserved.
//

import UIKit
import SwiftyVK


class AuthViewController: UIViewController {
    
    
    let appID = "5774191"
    let scope : Set<VK.Scope> = [.photos, .offline, .email, .messages]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func VKLoginPressed(_ sender: Any) {
        //VK.logOut()
        VK.logIn()
    }
    
}

