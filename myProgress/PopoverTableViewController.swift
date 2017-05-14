//
//  PopoverTableViewController.swift
//  myProgress
//
//  Created by Danya on 23.11.16.
//  Copyright © 2016 Danya. All rights reserved.
//

import UIKit

class PopoverTableViewController: UITableViewController {

    let names : [String] = ["Information", "Comments", "Programm"]
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: 310, height: 210)
        }
        
        set {
            super.preferredContentSize = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let VC = storyboard?.instantiateViewController(withIdentifier: "comments") as? CommentViewController
            let NavVC = UINavigationController(rootViewController: VC!)
            self.revealViewController().pushFrontViewController(NavVC, animated: true)
            //self.present(NavVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Papyrus", size: 30)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    

   }
