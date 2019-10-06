//
//  UIBarButtonItem+Catagory.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
extension UIBarButtonItem
{
    //class 表示类方法
    class func creatBarButtonItem(imageName:String , target:AnyObject?,action:Selector )->UIBarButtonItem
    {
        let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        leftBtn.setImage(UIImage(named: imageName + "_highlighted"), for: UIControl.State.highlighted)
        leftBtn.sizeToFit()
        leftBtn.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        return UIBarButtonItem(customView: leftBtn)
        
        
    }
    
    
}
