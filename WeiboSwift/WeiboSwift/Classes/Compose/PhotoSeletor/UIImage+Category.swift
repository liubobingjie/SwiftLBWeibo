//
//  UIImage+Category.swift
//  PictureSelectorDemo
//
//  Created by mc on 2019/9/7.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
extension UIImage
{
    //按照图片的g宽高比压缩图片
    func imageWithScale(width:CGFloat)->UIImage?
    {
        
        let height = width * (size.height / size.width)
        let currentSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContext(currentSize)
        draw(in: CGRect(origin: CGPoint.zero, size: currentSize))
        let newimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimage
    }
    
}
