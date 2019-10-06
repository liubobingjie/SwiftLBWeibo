//
//  StatusForwardViewCell.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class StatusForwardViewCell: StatusTableViewCell {
   override var status:Status?
    {
        didSet{
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            //forwardLabel.text = "@" + name + ": " + text
            
            forwardLabel.attributedText = EmoticPackage.emotconString(str: "@" + name + ": " + text)
        }
        
    }
   
    public override func setUpUI(){
        //先布局父类的
        super.setUpUI()
        //pictureView.snp.removeConstraints();
        //添加自己的子控件
       contentView.addSubview(forwardBtn)
        contentView.insertSubview(forwardBtn, belowSubview:pictureView)
        contentView.insertSubview(forwardLabel, aboveSubview: forwardBtn)
        
        forwardBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(10)
            make.left.equalTo(self.contentLabel).offset(-5)
            make.bottom.equalTo(self.footView.snp.top)
            make.right.equalTo(self.footView)
            
        }
        forwardLabel.snp.makeConstraints { (make) in
            make.top.equalTo(forwardBtn).offset(10)
            make.left.equalTo(forwardBtn).offset(10)
            make.width.equalTo(forwardBtn).offset(-20)
            
        }
        pictureView.snp.makeConstraints { (make) in
            make.left.equalTo(self.forwardLabel)
           self.pictureBottonCons = make.top.equalTo(self.forwardLabel.snp.bottom).offset(10).constraint
            self.pictureHeightCons  = make.height.equalTo(0).constraint
            self.pictureWidthCons = make.width.equalTo(0).constraint
            //make.height.width.equalTo(290)
        }
        
    }
    //MARK:懒加载
    //转发内容
    private lazy var forwardLabel:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.darkGray
        lab.text = "22danklefnlsfj"
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 0
        return lab
    }()
    private lazy var forwardBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        return btn
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    

}
