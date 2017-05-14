//
//  userModel.swift
//  myProgress
//
//  Created by Danya on 14.05.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit

class User: NSObject {
	
	var nickname: String?
	var email: String?
	var uid: String?
	
	init(with nick: String, mail: String, uid: String) {
		self.nickname = nick
		self.email = mail
		self.uid = uid
	}
	
}
