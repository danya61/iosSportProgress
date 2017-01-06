//
//  authViewController.swift
//  myProgress
//
//  Created by Danya on 10.11.16.
//  Copyright © 2016 Danya. All rights reserved.
//

import UIKit
import SwiftyVK

//var AvatarUrl : String = ""

class AuthViewController: UIViewController, VKDelegate {
    
    var isAuthorized : Bool?
    
    let appID = "5774191"
    let scope : Set<VK.Scope> = [.photos, .offline, .email, .messages]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        isAuthorized = defaults.bool(forKey: "isAuthorized")
        if isAuthorized! {
            VK.logOut()
            defaults.set(false, forKey: "isAuthorized")
        }
    }
    
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        return scope
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        if (VK.state == .authorized) {
            print("\n  did authorized      \(VK.state) \n")
            
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "isAuthorized")
            VK.API.Users.get([VK.Arg.fields: "photo_200_orig"]).send(
                onSuccess : {response in
                    defaults.set(response[0, "first_name"].stringValue as? String, forKey: "Name")
                    defaults.set(response[0, "photo_200_orig"].stringValue as? String, forKey: "Avatar")
            } ,
                onError : {error in print(error)}
            )
            
            print("registry")
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "main") as? MainViewController
            self.navigationController?.pushViewController(VC!, animated: true)
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    func vkAutorizationFailedWith(error: AuthError) {
        print("Autorization failed with error: \n\(error)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    
    
    func vkDidUnauthorize() {}
    
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    func vkWillPresentView() -> UIViewController {
        return self
    }
    
    @IBAction func VKLoginPressed(_ sender: Any) {
        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
        VK.logOut()
        VK.logIn()
    }
    
}

