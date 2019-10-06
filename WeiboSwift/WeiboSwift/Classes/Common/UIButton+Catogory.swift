//
//  UIButton+Catogory.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
extension UIButton{
    public class func creatButton(imageName:String,title:String)->UIButton{
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        btn.setTitle(title, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.darkText, for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControl.State.normal)
        return btn
        
    }
}
