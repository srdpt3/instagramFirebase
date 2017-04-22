//
//  User.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 22..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import Foundation


struct User {
    let uid : String
    let username: String
    let profileImageUrl: String
    
    init(uid:String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageURL"]  as? String ?? ""
    }
}

