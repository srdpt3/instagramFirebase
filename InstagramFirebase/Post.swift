//
//  Post.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 11..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit

struct Post{
    
    var id : String?
    let imageUrl : String
    let user : User
    let caption : String
    let creationDate : Date
    
    var hasLiked : Bool = false
    init(user : User, dict : [ String : Any]){
        
        self.imageUrl = dict["imageUrl"] as! String ?? ""
        self.user = user
        self.caption = dict["caption"] as! String ?? ""
        
        let secondsFrom1970 = dict["creationDate"] as! Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)

        
    }
}
