//
//  Animator.swift
//  BookingDemoSwift
//
//  Created by Igor Shukyurov on 22.04.17.
//  Copyright © 2017 Igor Shukyurov. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 0.33
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        let container = transitionContext.containerView
        
        toView.frame.origin.x = toView.frame.width
        toView.frame.origin.y = toView.frame.width / ((toView.frame.width - 75) / 22)
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
            toView.frame.origin.x = 0
            toView.frame.origin.y = 0
        }, completion: { success in
            transitionContext.completeTransition(success)
        })
    }
}

