//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 20..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
      //  fetchPost()
        
        fetchFollowingUserIds()
  
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDict = snapshot.value as? [String:Any] else { return }
            
            userIdsDict.forEach({ (key,value) in
                FIRDatabase.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostWithUser(user: user)
                })
            })
            
            
            
            
        }) { (err) in
            print("Failed to fetch following users", err)
        }
        
    }
    
    
    func setupNavigationItems(){
        
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height : CGFloat = 40+8+8 //username + userprofileImaview
        height+=view.frame.width
        height+=50 // bottom row
        height+=60
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        cell.post = posts[indexPath.row]
        
        return cell
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPost(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid  else { return }
        
        FIRDatabase.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostWithUser(user : User){

        let ref = FIRDatabase.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dicts = snapshot.value as? [String : Any] else { return }
            
            dicts.forEach({ (key, value) in
                guard let dict = value as? [String : Any] else { return }
                
                let post = Post(user : user, dict: dict)
                
                self.posts.append(post)
                
            })
            //Sort by creation Date
            self.posts.sort(by: { (p1, p2) -> Bool in
               return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch posts")
        }

        
        
    }
}
