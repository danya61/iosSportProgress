//
//  SearchTableViewController.swift
//  myProgress
//
//  Created by Danya on 14.05.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit
import Firebase

class SearchTableViewController: UITableViewController {

	var users = [User]()
	var photo = [PhotoModel]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchUsers()
	}

	func fetchUsers() {
		
		FIRDatabase.database().reference().child("photos").observe(.childAdded, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
			//	print("photo", dictionary["photo"], dictionary["owner"])
				let ph = PhotoModel(owner: dictionary["owner"] as! String, photo: dictionary["photo"] as! String)
				self.photo.append(ph)
			}
		}, withCancel: nil)
		
		
		FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				let user = User(with: dictionary["nickname"] as! String, mail: dictionary["email"] as! String, uid: snapshot.key)
				self.users.append(user)
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}, withCancel: nil)

	}


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var localUserPhoto = [String]()
		let uid = users[indexPath.row].uid
		for item in photo {
			print(uid!, item.owner!)
			if uid == item.owner {
				localUserPhoto.append(item.photo!)
			}
		}
		print("\n cnt = ", localUserPhoto.count)
		self.segToMain(with: localUserPhoto)
	}

	func segToMain(with ph: [String]) {
	//	let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rewealViewController") as? SWRevealViewController
		//let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! MainViewController
		//vc.owner = false
		//vc.photoURLs = ph
		//VC?.frontViewController = vc
		//self.revealViewController().pushFrontViewController(vc, animated: true)
	//	UIApplication.shared.delegate?.window??.rootViewController = vc
		
		var storyboard = UIStoryboard(name: "Main", bundle: nil)
		var rootViewController: MainViewController? = storyboard.instantiateViewController(withIdentifier: "main") as! MainViewController
		rootViewController?.owner = false
		rootViewController?.photoURLs = ph
		var navController = UINavigationController(rootViewController: rootViewController!)
		navController.setViewControllers([rootViewController!], animated: true)
		revealViewController().setFront(navController, animated: true)

	}

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			print("called")
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
				cell.textLabel?.text = users[indexPath.row].nickname!
			print("indexpath = ", indexPath.row)
				cell.detailTextLabel?.text = users[indexPath.row].email!
			
        return cell
    }
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return CGFloat(65)
	}

	
}
