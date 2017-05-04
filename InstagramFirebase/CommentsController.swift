//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 5. 2..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellId"
    var post : Post?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "댓글"
        collectionView?.backgroundColor = .red
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        
        collectionView?.register(CommentsCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchComments()
        
    }
    var comments  = [Comment]()
    fileprivate func fetchComments(){
        guard let postId = self.post?.id else {return}
        let ref = FIRDatabase.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? [String : Any] else { return }
            
            let comment = Comment(dict: dict)
            self.comments.append(comment)
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to observe comments")
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentsCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("게시", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)
        
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        return containerView
    }()
    
    let commentTextField : UITextField = {
        
        let textField  = UITextField()
        textField.placeholder = "댓글..."
        return textField
        
    }()
    
    func handleSubmit(){
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        print(post?.id)
        
        
        guard let postID = self.post?.id else { return }
        let value = ["text" : commentTextField.text ?? "", "creationDate":Date().timeIntervalSince1970, "uid" : uid] as [ String : Any]
        
        FIRDatabase.database().reference().child("comments").child(postID).childByAutoId().updateChildValues(value) { (err, ref) in
            
            if let err = err{
                print("failed to insert comments", err)
                return
                
            }
            
            
            print("successfully inserted comments")
            
        }
        print("submit")
        
    }
    
    override var inputAccessoryView: UIView? {
        get{
            return containerView
            
        }
        
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
}
