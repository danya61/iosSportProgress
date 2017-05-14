//
//  WeekBodyViewController.swift
//  myProgress
//
//  Created by Danya on 19.03.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit

class WeekBodyViewController: UIViewController {

	@IBOutlet weak var SWButton: UIBarButtonItem!
	let usersName = ["Berzerk161", "enemyWard", "WebAnt", "NiceUser"]
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.tableFooterView = UIView()
			tableView.separatorStyle = .none
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.automaticallyAdjustsScrollViewInsets = false
		tableView.contentInset = UIEdgeInsets.zero
		tableView.register(UINib(nibName: "WeekProgressXib", bundle: nil), forCellReuseIdentifier: "WeekProgressXib")
		tableView.delegate = self
		if self.revealViewController() != nil{
			SWButton.target  = self.revealViewController()
			SWButton.action = #selector(SWRevealViewController.revealToggle(_:))
			self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
		}
		self.revealViewController().rearViewRevealWidth = 260

	}

	override func didReceiveMemoryWarning() {
			super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
	}

}


extension WeekBodyViewController : UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 10
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return usersName.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		print("call")
		let cell = tableView.dequeueReusableCell(withIdentifier: "WeekProgressXib") as! WeekProgressTableViewCell
		print(cell)
		cell.userName.text = usersName[indexPath.section]
		cell.personalProgress.text = "0.98"
		cell.personalProgress.textColor = UIColor.red
		cell.personalRating.text = "8"
		//cell.avatarImage.layer.cornerRadius = 25
		cell.avatarImage.image = #imageLiteral(resourceName: "obama")
		return cell
	}
	
	
}

