//
//  FireBaseUtil.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 22..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import Foundation
import Firebase

extension FIRDatabase{
    static func fetchUserWithUID(uid : String, completion: @escaping (User)->()){
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDict = snapshot.value as? [String:Any] else { return }
            
            let user = User(uid: uid, dictionary: userDict)
            
            //  self.fetchPostWithUser(user : user)
            
            completion(user)
            
        }) { (err) in
            print("failed to fetch user for posts " ,err)
        }
        
    }
    
}
