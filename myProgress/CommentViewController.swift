//
//  CommentViewController.swift
//  myProgress
//
//  Created by Danya on 29.12.16.
//  Copyright © 2016 Danya. All rights reserved.
//

import UIKit


class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    @IBOutlet weak var SWButton: UIBarButtonItem!
    @IBOutlet weak var Comentsext: UITextView!
    @IBOutlet weak var tableview: UITableView!

    var keyboardSz : CGRect?
    var cellSize : CGSize?
    
    var comments = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.Comentsext.delegate = self
          if self.revealViewController() != nil{
            SWButton.target  = self.revealViewController()
            SWButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
        self.revealViewController().rearViewRevealWidth = 260
        Comentsext.layer.cornerRadius = 20
        tableview.tableFooterView = UIView()
    }

    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                keyboardSz = keyboardSize
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
   
    
    @IBAction func btnPressed(_ sender: Any) {
        comments.append(Comentsext.text)
        self.tableview.reloadData()
        Comentsext.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.darkGray
        let lb = cell.viewWithTag(1) as? UILabel
        lb?.text = comments[indexPath.section]
        lb?.numberOfLines = 0
        lb?.lineBreakMode = .byWordWrapping
        lb?.sizeToFit()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame : CGRect = tableView.frame
        let userBtn : UIButton = UIButton(frame: CGRect(x: frame.size.width / 7, y: 0, width: 200, height: 35))
        userBtn.setTitle("Berzerker161 :", for: .normal)
        userBtn.backgroundColor = UIColor.clear
        userBtn.titleLabel?.font = UIFont(name: "Menlo", size: 21)
        
        userBtn.addTarget(self, action: #selector(CommentViewController.buttonTapped(sender:)), for: .touchUpInside)
        let headerV : UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        headerV.backgroundColor = UIColor.gray
        headerV.addSubview(userBtn)
        return headerV
    }
    
    func buttonTapped(sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.5
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
}
