//
//  PhotoModel.swift
//  myProgress
//
//  Created by Danya on 14.05.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import Foundation

class PhotoModel: NSObject {
	var owner: String?
	var photo: String?
	
	init(owner: String, photo: String) {
		self.owner = owner
		self.photo = photo
	}
}
