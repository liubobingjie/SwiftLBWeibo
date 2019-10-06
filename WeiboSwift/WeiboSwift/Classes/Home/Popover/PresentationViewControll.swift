//
//  PresentationViewControll.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class PresentationViewControll: UIPresentationController
{
   public var presentFram = CGRect.zero
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
       super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        
    }
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        if presentFram == CGRect.zero {
            presentedView?.frame = CGRect(x: 100, y: 56, width: 200, height: 200)
        }else{
            presentedView?.frame = presentFram
        }
        
        containerView?.insertSubview(conview, at: 0)
        
    }
    
    //MARK: 懒加载蒙版
    private lazy var conview:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        view.frame = UIScreen.main.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(PresentationViewControll.tapDiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    @objc public func tapDiss(tap:UITapGestureRecognizer){
        presentedViewController.dismiss(animated: true, completion: nil)
    }

}
