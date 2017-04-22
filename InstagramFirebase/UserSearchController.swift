//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 4. 22..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit
import Firebase


class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var cellId = "cellId"
    let searchBar : UISearchBar = {
       let sb = UISearchBar()
        sb.placeholder = "검색"
        sb.barTintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230  , green: 230, blue: 230)
        return sb
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.addSubview(searchBar)
        collectionView?.backgroundColor = .white

        guard let navBar = navigationController?.navigationBar  else { return }
        
        searchBar.anchor(top: navBar.topAnchor, left: navBar.leftAnchor, bottom: navBar.bottomAnchor, right: navBar.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView?.register(UsersearchCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!  UsersearchCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 66)
    }
    
}
