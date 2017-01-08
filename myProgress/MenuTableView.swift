//
//  MenuTableView.swift
//  myProgress
//
//  Created by Danya on 04.11.16.
//  Copyright © 2016 Danya. All rights reserved.
//

import UIKit
import SwiftyVK


class MenuTableView: UIViewController {
    
    var AvatarURL : String? = ""
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var activityInd = UIActivityIndicatorView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            var nm : String?
        
        activityInd.center = CGPoint(x: self.view.center.x * 3 / 4, y: self.view.center.y / 3)
        activityInd.hidesWhenStopped = true
        activityInd.color = UIColor.white
        activityInd.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(activityInd)
        activityInd.startAnimating()
        VK.API.Users.get([VK.Arg.ownerId : myPublicId, .fields : "photo_200_orig"]).send(
                onSuccess: {response in
                    //print(response)
                    self.AvatarURL = response[0, "photo_200_orig"].stringValue as? String
                    print(self.AvatarURL!)
                    DispatchQueue.main.async {
                        //self.nameLb.text = "11111"
                        let url = URL(string: self.AvatarURL!)
                        let data = try? Data(contentsOf: url!)
                        self.avatarImage.image = UIImage(data: data!)
                        self.activityInd.stopAnimating()
                    }

            },
                onError: {error in
                    print(error)
                    self.nameLb.text = "11111"
            }
            )
            /*VK.API.Users.get([VK.Arg.fields: "photo_200_orig"]).send(
                onSuccess : {response in
                    nm = response[0, "first_name"].stringValue as? String
                    self.AvatarURL = response[0, "photo_200_orig"].stringValue as? String
            } ,
                onError : {error in
                    print("bad")
                    print(error)}
            ) */
            
            //print("its OK data of URL \n")
            //nameLb.text = nm
        tableView.tableFooterView = UIView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 15
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.masksToBounds = false
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

let cellMenuId : String = "Cell"

let cellsNames = ["My Profile", "Comments", "Week Progress", "Week Body", "Search Users"]

extension MenuTableView : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellMenuId, for: indexPath) as! MenuTableViewCell
        
        cell.ResourseLb.font = UIFont(name:"Papyrus" , size: 25)
        cell.ResourseLb.text = cellsNames[indexPath.row]
        cell.imgCell.contentMode = .scaleAspectFill
        cell.imgCell.clipsToBounds = true
        switch indexPath.row {
        case 0:
            cell.imgCell.image = #imageLiteral(resourceName: "prof")
        case 1:
            cell.imgCell.image = #imageLiteral(resourceName: "comms")
        case 2:
            cell.imgCell.image = #imageLiteral(resourceName: "progress")
        case 3:
            cell.imgCell.image = #imageLiteral(resourceName: "body")
        case 4:
            cell.imgCell.image = #imageLiteral(resourceName: "search")
        default:
            break
        }
        cell.imgCell.layer.cornerRadius = cell.imgCell.bounds.height / 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var VC = UIViewController()
        var NavVC = UINavigationController()
        if indexPath.row == 0 {
            VC = (self.storyboard?.instantiateViewController(withIdentifier: "main") as? MainViewController)!
            NavVC = UINavigationController(rootViewController: VC)
            
        }
        if indexPath.row == 1 {
            VC = (self.storyboard?.instantiateViewController(withIdentifier: "comments") as? CommentViewController)!
            NavVC = UINavigationController(rootViewController: VC)
        }
        self.revealViewController().pushFrontViewController(NavVC, animated: true)
        //self.navigationController?.present(VC, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
}
