//
//  TitleButton.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
       setImage(UIImage(named: "navigationbar_arrow_down"), for: UIControl.State.normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: UIControl.State.selected)
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /*方案一
        titleLabel?.frame.offsetBy(dx: -(imageView?.bounds.width ?? 0), dy: 0)
        imageView?.frame.offsetBy(dx: titleLabel?.bounds.width ?? 0, dy: 0)*/
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
    }

}
