//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 5. 3..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import Foundation


struct Comment {
    let text : String
    let uid : String
    var user : User
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
