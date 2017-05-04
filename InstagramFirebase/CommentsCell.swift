
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
                textLabel.text = comment?.text
        }
    }
    
    let textLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.numberOfLines = 0
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        backgroundColor = .lightGray
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
