//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 20..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController , UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  let name = NSNotification.Name(rawValue: "UploadFeed")
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedName, object: nil)
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        setupNavigationItems()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        collectionView?.refreshControl = refreshControl;
        fetchAllPost()
        
    }
    
    func handleUpdateFeed(){
        handleRefresh()
    }
    
    func handleRefresh(){
        
        posts.removeAll()
        
        fetchAllPost()
    }
    
    fileprivate func fetchAllPost(){
        
        fetchPost()
        
        fetchFollowingUserIds()
    }
    
    fileprivate func fetchFollowingUserIds(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        
    }
    
    func handleCamera(){
        
        let cameraController = CameraController()
        
        present(cameraController, animated: true, completion: nil)
        
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
        
        cell.delegate = self
        
        return cell
    }
    
    
    func didTapComment(post: Post) {
        print("message coming from homecontroller")
        
        print(post.caption)
        let commentsController  = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    
    func didLike(for cell: HomePostCell) {
        print("message cLike")
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        
        var post = self.posts[indexPath.item]
        print(post.caption)
        
        guard let postId = post.id else { return }
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        let values = [uid : post.hasLiked == true ? 0 : 1]
        
        FIRDatabase.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
            
            if let err = err {
                print("error save liked")
                return
            }
            
            print("succesfully liked")
            
            post.hasLiked = !post.hasLiked
            
            self.posts[indexPath.item] = post
            
            self.collectionView?.reloadItems(at: [indexPath])
            
            
        }
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
                
                var post = Post(user : user, dict: dict)
                post.id = key
                
                guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
            FIRDatabase.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                if let value = snapshot.value as? Int, value == 1{
                    post.hasLiked = true
                }else{
                    post.hasLiked = false
                }
                
                
                self.posts.append(post)
                //Sort by creation Date
                self.posts.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self.collectionView?.reloadData()


                
                
                }, withCancel: { (err) in
                    print("Failed tp fetch like info for post", err)
                })
                
                
              
                
            })
            
        }) { (err) in
            print("Failed to fetch posts")
        }
        
        
        
    }
}
