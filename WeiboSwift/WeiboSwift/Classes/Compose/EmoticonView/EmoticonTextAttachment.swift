//
//  EmoticonTextAttachment.swift
//  EmoticonDemo
//
//  Created by mc on 2019/9/3.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    // 保存对应表情的文字
    var chs: String?
    class  func imageText (emoticon:Emoticon , font:CGFloat)-> NSAttributedString{
        
        let attachment = EmoticonTextAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
        attachment.bounds = CGRect(x: 0, y: -4, width: font, height: font)
        
        return NSAttributedString(attachment: attachment)
    
    }
    
    
}
