//
//  FullImageViewController.swift
//  myProgress
//
//  Created by Danya on 09.11.16.
//  Copyright © 2016 Danya. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    var img : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.contentMode = .scaleAspectFit
        image.image = img
        
        let upRec = UISwipeGestureRecognizer(target: self, action: #selector(FullImageViewController.back(gestureRecognizer:)))
        upRec.direction = .up
        self.view.addGestureRecognizer(upRec)
    }

    func back(gestureRecognizer : UISwipeGestureRecognizer){
        self.performSegue(withIdentifier: "backToProfile", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
