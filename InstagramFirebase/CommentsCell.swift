
//
//  CommentsCell.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 5. 3..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit


class  CommentsCell: UICollectionViewCell {
    
    var comment : Comment?{
        didSet{
            
            guard let comment = comment else { return }
            let attributedText = NSMutableAttributedString(string: (comment.user.username), attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
            
            textView.attributedText = attributedText
            print(comment.user.profileImageUrl)
            profileImageView.loadImage(urlString: comment.user.profileImageUrl)
        }
    }
    
    let textView : UITextView = {
        let lb = UITextView()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.isScrollEnabled = false
        return lb
    }()
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubview(textView)
        addSubview(profileImageView)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40/2
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
