//
//  UILabel+Catogory.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
extension UILabel{
    
 public class func creatLabel(color:UIColor,font:UIFont) -> UILabel{
        let lab = UILabel()
        lab.textColor = color
        lab.font = font
        return lab
    }
}
