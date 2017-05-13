//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Dustin Yang on 3/22/17.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout , UserProfileHeaderDelegate{
    
    let cellId = "cellId"
    let headerId = "headerId"
    let homePostCellId = "homePostCellId"
    
    
    var userId  : String?
    
    var isGridView = true
    var isListView = true
    
    func didChangeToListview() {
        isGridView = false
        collectionView?.reloadData()
        
    }
    
    func didChangeToGridview() {
        isGridView = true
        collectionView?.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
        setupLogOutButton()
        //  fetchOrderdPosts()
    }
    
    
    var posts = [Post]()
    
    fileprivate func fetchOrderdPosts(){
        
        guard let uid = self.user?.uid else { return }
        
        
        let ref = FIRDatabase.database().reference().child("posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            
            guard let dicts = snapshot.value as? [String : Any] else { return }
            
            guard let user = self.user else { return }
            let post = Post(user : user, dict: dicts)
            
            self.posts.insert(post, at: 0) //like a stack, last in  = first image shown
            self.collectionView?.reloadData()
            
        }) { (err) in
            print(err)
        }
    }
    
    
    
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try FIRAuth.auth()?.signOut()
                
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                
                self.present(navController, animated: true, completion: nil)
                
                
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isGridView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridView{
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            
            var height : CGFloat = 40+8+8 //username + userprofileImaview
            height+=view.frame.width
            height+=50 // bottom row
            height+=60
            
            return CGSize(width: view.frame.width, height: height)
                    }
        
        
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        
        header.user = self.user
        
        header.delegate = self
        
        //not correct
        //header.addSubview(UIImageView())
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user: User?
    fileprivate func fetchUser() {
        
        let uid = userId ?? (FIRAuth.auth()?.currentUser?.uid ?? "")
        
        FIRDatabase.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            self.fetchOrderdPosts()
        }
    }
}




