//
//  authViewController.swift
//  myProgress
//
//  Created by Danya on 10.11.16.
//  Copyright © 2016 Danya. All rights reserved.
//

import UIKit
import SwiftyVK
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let appID = "5774191"
    let scope : Set<VK.Scope> = [.photos, .offline, .email, .messages]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func registryPressed(_ sender: Any) {
        if login.text != "" && password.text != "" {
            FIRAuth.auth()?.createUser(withEmail: login.text!, password: password.text!, completion: { (user, error) in
                if error != nil {
                    print(error.debugDescription)
                } else {
                   print(user?.uid)
                }
            })
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func VKLoginPressed(_ sender: Any) {
        //VK.logOut()
        VK.logIn()
    }
    
}

