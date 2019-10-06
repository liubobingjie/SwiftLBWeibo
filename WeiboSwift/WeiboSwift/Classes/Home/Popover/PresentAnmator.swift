//
//  PresentAnmator.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

/// 在类的外面写的常量或者变量就是全局能够访问的
let XMGPopoverAnimatorShowNotification = "XMGPopoverAnimatorShowNotification"
let XMGPopoverAnimatorDismissNotification = "XMGPopoverAnimatorDismissNotification"

class PresentAnmator: NSObject,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning
{
     var isPresent:Bool = false
   public var presentFram = CGRect.zero
    
    //UIPresentationController专门用于转场动画
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
        return PresentationViewControll(presentedViewController: presented, presenting: presenting)
    }
    //展现动画
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = true
        //发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: XMGPopoverAnimatorDismissNotification), object: self)
        
        return self
        
    }
    //消失动画
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresent = false
        NotificationCenter.default.post(name: NSNotification.Name(XMGPopoverAnimatorDismissNotification), object: self)
        
        return self
    }
    
    //MARK:-UIViewControllerAnimatedTransitioning
    //返回动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    //返回h如动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            let tovc = transitionContext.view(forKey: .to)!
            tovc.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            //tovc?.transform = CGAffineTransform(scaleX: 1.0,y: 0.0)
            transitionContext.containerView.addSubview(tovc)
            tovc.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animate(withDuration: 0.5, animations: {
                tovc.transform = .identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }else{
            let fromVc = transitionContext.view(forKey: UITransitionContextViewKey.from)
            UIView.animate(withDuration: 0.2, animations: {
                fromVc?.transform = CGAffineTransform(scaleX:1.0,y:0.0001)
                
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
        
        
    }
    
} 
