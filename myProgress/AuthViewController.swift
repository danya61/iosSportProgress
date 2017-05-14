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
import FirebaseDatabase


class AuthViewController: UIViewController {

	@IBOutlet weak var login: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var nickname: UITextField!
    
    let appID = "5774191"
    let scope : Set<VK.Scope> = [.photos, .offline, .email, .messages]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if isAuth {
            segToMain()
        }
    }
    
    func segToMain() {
        let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rewealViewController") as? SWRevealViewController
        UIApplication.shared.delegate?.window??.rootViewController = VC
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        if login.text != "" && password.text != "" {
            FIRAuth.auth()?.signIn(withEmail: login.text!, password: password.text!, completion: { (user, error) in
                if error != nil {
                    print(error.debugDescription)
                    var alert = UIAlertController(title: "OOOPS", message: "Wrong e-mail or password!", preferredStyle: .alert)
                    var actOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(actOK)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    isAuth = true
                    self.segToMain()
                }
            })
        }
    }
    
    
    @IBAction func registryPressed(_ sender: Any) {
        if login.text != "" && password.text != "" {
            FIRAuth.auth()?.createUser(withEmail: login.text!, password: password.text!, completion: { (user, error) in
                if error != nil {
                    print(error.debugDescription)
                    let alert = UIAlertController(title: "OOOPS", message: "this e-mail already received", preferredStyle: .alert)
                    let actOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(actOK)
                    self.present(alert, animated: true, completion: nil)
                } else {
										isAuth = true
									guard let uid = user?.uid else {
										return
									}
                    let ref = FIRDatabase.database().reference(fromURL: "https://bodyprogress-b3f15.firebaseio.com/")
                    let userRef = ref.child("users").child(uid)
									let values = ["email" : self.login.text, "nickname": self.nickname.text]
                    userRef.updateChildValues(values, withCompletionBlock: { (error,ref) in
											guard error == nil else { return}
											isAuth = true
											self.segToMain()
                    })
                }
            })
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func VKLoginPressed(_ sender: Any) {
        VK.logIn()
    }
    
}

