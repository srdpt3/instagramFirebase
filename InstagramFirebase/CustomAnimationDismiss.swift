//
//  CustomAnimationDismiss.swift
//  InstagramFirebase
//
//  Created by Dustin yang on 2017. 5. 1..
//  Copyright © 2017년 Dustin Yang. All rights reserved.
//

import UIKit

class CustomAnimationDismiss: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        containerView.addSubview(toView)
        
      //  let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
      //  toView.frame = startingFrame
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            
        }) { (_) in
            transitionContext.completeTransition(true)
            
        }
        
    }
    

    
}
