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
    
    init(dict : [String : Any]) {
        self.text  = dict["text"] as? String ?? ""
        self.uid  = dict["uid"] as? String ?? ""

    }
}
