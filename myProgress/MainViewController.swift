//
//  MainViewController.swift
//  myProgress
//
//  Created by Danya on 03.11.16.
//  Copyright © 2016 Danya. All rights reserved.
//

import UIKit
import CoreData
import SwiftyVK

var authorized = false;
var personImg = UIImage()
var lb = [NSManagedObject]()

let cellId = "cell"

class MainViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate,
UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate,
UIPopoverPresentationControllerDelegate{

    @IBAction func unwindToMenu(segue: UIStoryboardSegue){
    }
    @IBOutlet weak var ColView: UICollectionView!
    @IBOutlet weak var navButton: UIButton!
    @IBOutlet weak var SWButton: UIBarButtonItem!
    let picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil{
            SWButton.target  = self.revealViewController()
            SWButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.revealViewController().rearViewRevealWidth = 260
        
        
        
        ColView.delegate = self
        ColView.dataSource = self
        
        let longPressG = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.longPress(gestureRecognizer:)))
        longPressG.minimumPressDuration = 1
        longPressG.delegate = self
        longPressG.delaysTouchesBegan = true
        self.ColView?.addGestureRecognizer(longPressG)
        
        
        
        let but = UIButton.init(type: .custom)
        but.frame = CGRect(x: 0, y: 0, width: 30, height: 31)
        but.setImage(#imageLiteral(resourceName: "login"), for: .normal)
        but.addTarget(self, action: #selector(MainViewController.logInPressed), for: .touchUpInside)
        let barButtonRight = UIBarButtonItem()
        barButtonRight.customView = but
        self.navigationItem.rightBarButtonItem = barButtonRight
        //self.navigationItem.title = "Profile"
        navButton.setTitle("Profile ↓", for: .normal)
        
        picker.delegate = self
        fetch()
    }
    

    
    func fetch() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appdelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        do {
            let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            lb = result!
            
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }
 
    func longPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != UIGestureRecognizerState.began){
            return
        }
        let num = gestureRecognizer.location(in: self.ColView)
        if let indexPath = self.ColView?.indexPathForItem(at: num) {
            if indexPath.row != lb.count  {
                print(indexPath.row)
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "fullPhoto") as? FullImageViewController
                let indObj = lb[indexPath.row]
                //VC?.image.contentMode = .scaleToFill
                let curImg = UIImage(data: indObj.value(forKey: "image") as! Data, scale: 1.0)
                VC?.img = curImg
                self.present(VC!, animated: true, completion: nil)
            } else {
                print("badIndex")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveCnt(newDate : String, imgData : NSData) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        let entity =  NSEntityDescription.entity(forEntityName: "Photos",in: managedContext)
        let manObj = NSManagedObject(entity: entity!, insertInto: managedContext)
        manObj .setValue(newDate, forKey: "labelVal")
        manObj .setValue(imgData, forKey: "image")
        do {
            try managedContext.save()
            lb.append(manObj)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        personImg = chosenImage
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "FirstIn") {
            print("FirstIn \n")
            makeNotif()
            defaults.set(true, forKey: "FirstIn")
        }
        
        dismiss(animated:true, completion: { () in
            let curdate = Date()
            let dateForm = DateFormatter()
            dateForm.locale = Locale.current
            dateForm.dateStyle = .medium
            let newDate = dateForm.string(from: curdate)
            let imgData = NSData(data: UIImageJPEGRepresentation(personImg, 1.0)!)
            self.saveCnt(newDate: newDate , imgData: imgData)
            self.ColView.reloadData()
        })
    }
    

    func logInPressed(){
        print("pressed \n")
        VK.logOut()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //  print("snova \n")
        return lb.count + 1
    }
    
    var cnt = 0
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MainCollectionViewCell
        if indexPath.row != lb.count {
            let indObj = lb[indexPath.row]
            cells?.imgCell.contentMode = .scaleToFill
            let curImg = UIImage(data: indObj.value(forKey: "image") as! Data, scale: 1.0)
            cells?.layer.cornerRadius = 10
            cells?.imgCell.image = curImg
            cells?.lblCell.text = indObj.value(forKey: "labelVal") as! String?
        }
        else if indexPath.row == lb.count {
            cells?.imgCell.contentMode = .scaleAspectFit
            cells?.imgCell.image = #imageLiteral(resourceName: "camera")
            cells?.lblCell.text = "Photo Date"
        }
        return cells!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSpacing = CGFloat(5) //Define the space between each cell
        let leftRightMargin = CGFloat(10) //If defined in Interface Builder for "Section Insets"
        //let numColumns = CGFloat(2) //The total number of columns you want
        
        let totalCellSpace = cellSpacing
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let width = (screenWidth - leftRightMargin - totalCellSpace) * 3 / 4
        let height =  screenHeight - collectionView.frame.height / 2 //whatever height you want
        return CGSize(width: width, height: CGFloat(height))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        authorized = defaults.bool(forKey: "isAuthorized")
        if indexPath.row ==  lb.count  && authorized {
            let alert = UIAlertController(title: "Photo your Body!", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
            /*  let libButton = UIAlertAction(title: "Select photo from library", style: UIAlertActionStyle.default) { (alert: UIAlertAction!) -> Void in
             self.picker.allowsEditing = false
             self.picker.sourceType = .photoLibrary
             self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
             self.present(self.picker, animated: true, completion: nil)
             } */
            let cameraButton = UIAlertAction(title: "Take a picture", style: UIAlertActionStyle.default) { (alert: UIAlertAction!) -> Void in
                self.picker.allowsEditing = false
                self.picker.sourceType = .camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert: UIAlertAction!) -> Void in
                
            }
            
            //   alert.addAction(libButton)
            alert.addAction(cancelButton)
            alert.addAction(cameraButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    func makeNotif() {
        
        let notif = UILocalNotification()
        if #available(iOS 8.2, *) {
            notif.alertTitle = "Take Photo!"
        } else {
        }
        notif.alertBody = "Lets make a new Photo!"
        notif.alertAction = "Go!"
        notif.soundName = UILocalNotificationDefaultSoundName
        
        
        notif.fireDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 7) //dataForce
        notif.repeatInterval = NSCalendar.Unit.weekOfYear
        UIApplication.shared.scheduleLocalNotification(notif)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ppcs" {
            if let testPPVC = segue.destination as? PopoverTableViewController {// as? PopoverTableViewController {
                if let ppc = testPPVC.popoverPresentationController {
                    ppc.sourceRect = CGRect(x: navButton.bounds.size.width / 2, y: navButton.bounds.size.height / 2 + 12, width: 1, height: 1)
                    ppc.sourceView = navButton
                    ppc.delegate = self
                }
            }
        }
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


