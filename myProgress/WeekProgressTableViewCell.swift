
//
//  WeekProgressTableViewCell.swift
//  myProgress
//
//  Created by Danya on 18.03.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit

class WeekProgressTableViewCell: UITableViewCell {

	@IBOutlet weak var avatarImage: UIImageView! {
		didSet {
			avatarImage.layer.masksToBounds = true
			avatarImage.layer.cornerRadius = 15
		}
	}
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var personalProgress: UILabel!
	@IBOutlet weak var personalRating: UILabel!
	
    override func awakeFromNib() {
			super.awakeFromNib()
			
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
