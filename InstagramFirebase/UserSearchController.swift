//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 22..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit
import Firebase


class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout , UISearchBarDelegate{
    
    var cellId = "cellId"
    

    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "검색"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230  , green: 230, blue: 230)
        sb.delegate = self
        return sb
        
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            filteredUsers = users
        }else{
            self.filteredUsers =  self.users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
                
            }
            
        }
        
        self.collectionView?.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.addSubview(searchBar)
        collectionView?.backgroundColor = .white
        
        guard let navBar = navigationController?.navigationBar  else { return }
        
        searchBar.anchor(top: navBar.topAnchor, left: navBar.leftAnchor, bottom: navBar.bottomAnchor, right: navBar.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView?.register(UsersearchCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        fetchUsers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.isHidden = false

    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder() // Hide Keyboard
        
        let user = filteredUsers[indexPath.item]
        print(user.username)
        
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        userProfileController.userId = user.uid
        
        navigationController?.pushViewController(userProfileController, animated: true)
        
    }
    
    var filteredUsers = [User]()
    var users = [User]()
    
    fileprivate func fetchUsers(){
        
        let ref = FIRDatabase.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dict = snapshot.value as? [String: Any] else { return }
            
            dict.forEach({ (key,value) in
                guard let userDict = value as? [String : Any] else { return }
                
                if key != FIRAuth.auth()?.currentUser?.uid{
                    let user = User(uid: key, dictionary: userDict)
                    self.users.append(user)
                }
                
                
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch users for search" , err)
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!  UsersearchCell
        
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
}
