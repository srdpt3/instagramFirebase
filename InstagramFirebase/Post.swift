//
//  Post.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 11..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit

struct Post{
    let imageUrl : String
    let user : User
    let caption : String
    
    init(user : User, dict : [ String : Any]){
        
        self.imageUrl = dict["imageUrl"] as! String ?? ""
        self.user = user
        self.caption = dict["caption"] as! String ?? ""
    }
}
