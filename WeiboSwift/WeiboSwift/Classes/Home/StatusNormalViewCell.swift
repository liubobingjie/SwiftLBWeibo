//
//  StatusNormalViewCell.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class StatusNormalViewCell: StatusTableViewCell {
    
    override func setUpUI() {
        super.setUpUI()
        pictureView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentLabel)
            make.top.equalTo(self.contentLabel.snp.bottom).offset(10)
            self.pictureHeightCons  = make.height.equalTo(0).constraint
            self.pictureWidthCons = make.width.equalTo(0).constraint
            //make.height.width.equalTo(290)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   

}
