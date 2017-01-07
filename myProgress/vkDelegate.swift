import UIKit
import SwiftyVK

var myPublicId : String = ""

class vkDelegate : VKDelegate {
    
    
    let appID = "5774191"
    let scope : Set<VK.Scope> = [.photos, .offline, .email, .messages]
    
    
    init() {
        VK.config.logToConsole = true
        VK.configure(withAppId: appID, delegate: self)
        
    }
    
    
    func vkWillAuthorize() -> Set<VK.Scope> {
        return scope
    }
    
    func vkDidAuthorizeWith(parameters: Dictionary<String, String>) {
        
        if (VK.state == .authorized) {
            myPublicId = parameters["user_id"]!
            print("\n  did authorized      \(VK.state) \n")
            
            
            
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rewealViewController") as? SWRevealViewController
            let navVC = UINavigationController(rootViewController: VC!)
            UIApplication.shared.delegate?.window??.rootViewController =  VC
            
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidAuthorize"), object: nil)
    }
    
    func vkAutorizationFailedWith(error: AuthError) {
        print("Autorization failed with error: \n\(error)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TestVkDidNotAuthorize"), object: nil)
    }
    
    
    
    func vkDidUnauthorize() {
        let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "auth") as? AuthViewController
        UIApplication.shared.delegate?.window??.rootViewController = VC
    }
    
    func vkShouldUseTokenPath() -> String? {
        return nil
    }
    
    func vkWillPresentView() -> UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
}
