//
//  UITextView+Category.swift
//  EmoticonDemo
//
//  Created by mc on 2019/9/4.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
extension UITextView
{
    func insetEmoticon(emoticon:Emoticon,font:CGFloat) {
        //删除
        if emoticon.isRemoveButton{
            deleteBackward()
        }
        
        if emoticon.emojiStr != nil{
            //替换光标位子
            replace(selectedTextRange!, withText: emoticon.emojiStr!)
        }
        //判断当前是否是表情图片
        if emoticon.png != nil{
//            let attachment = EmoticonTextAttachment()
//            attachment.image = UIImage(contentsOfFile: emoticon.imagePath!)
//            attachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
//            let imageText = NSAttributedString(attachment: attachment)
            
            let imageText = EmoticonTextAttachment.imageText(emoticon: emoticon, font: font)
            let strM = NSMutableAttributedString(attributedString: attributedText)
            
            let range = selectedRange
            
            strM.replaceCharacters(in: range, with: imageText)
            
            //回复字体大小
            strM.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 19), range: NSMakeRange(range.location, 1))
            
            attributedText = strM
            //回复光标  制定光标位子 0 选中的个数
            selectedRange = NSMakeRange(range.location + 1, 0)
            
            delegate?.textViewDidChange!(self)
    }
    }
    
    func emoticonAttributedText() -> String{
        var strM = String()
       attributedText.enumerateAttributes(in: NSMakeRange(0, attributedText.length), options: NSAttributedString.EnumerationOptions(rawValue: NSAttributedString.EnumerationOptions.RawValue(0))) { (objc, range, _) in
        
            print(objc)
            
            let str = NSAttributedString.Key.attachment
            if objc[str] != nil{
                let attachment =  objc[str] as! EmoticonTextAttachment
                strM = strM + attachment.chs!
            }else
            {
                strM = strM + (self.text as NSString).substring(with: range)
            }
            
            
        }
         return strM
        
    }
    
}
