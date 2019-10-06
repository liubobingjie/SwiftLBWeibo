//
//  CellHeadView.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

 class CellHeadView: UIView {
    private let width = UIScreen.main.bounds.size.width
    
   var Headstatus:Status?
    {
        didSet{
            nameLabel.text = Headstatus?.user?.name
            
            //设置来源
            sourceLabel.text = Headstatus?.source
            
            timeLabel.text = Headstatus?.created_at
            
           // contentLabel.text = status?.text
            //设置用户头像
            if let iconViewUrl = Headstatus?.user?.profile_image_url{
                iconView.kf.setImage(with:URL(string:iconViewUrl))
            }
            verFiledView.image = Headstatus?.user?.verified_img
            vipView.image = Headstatus?.user?.memberImage
            
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        addSubview(iconView)
        addSubview(verFiledView)
        addSubview(nameLabel)
        addSubview(vipView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
       // addSubview(contentLabel)
        
        iconView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(50)
            
        }
        verFiledView.snp.makeConstraints { (make) in
            make.width.height.equalTo(14)
            make.top.equalTo(self.iconView.snp.bottom).offset(-8)
            make.left.equalTo(self.iconView.snp.right).offset(-8)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconView)
            make.left.equalTo(self.iconView.snp.right).offset(10)
        }
        vipView.snp.makeConstraints { (make) in
            make.height.width.equalTo(14)
            make.left.equalTo(self.nameLabel.snp.right).offset(10)
            make.top.equalTo(self.nameLabel)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.iconView)
            make.left.equalTo(self.iconView.snp.right).offset(10)
        }
        sourceLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.timeLabel)
            make.left.equalTo(self.timeLabel.snp.right).offset(10)
        }
    }
    //Mark:
   
    ///MARK:--懒加载
    //头像
    private lazy var iconView:UIImageView = {
        let vi = UIImageView(image: UIImage(named: "avatar_default"))
        vi.layer.cornerRadius = 25
        vi.layer.masksToBounds = true
        return vi
    }()
    //认证图标
    private lazy var verFiledView:UIImageView = {
        let vi = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
        return vi
    }()
    //妮称
    
    private lazy var nameLabel = UILabel.creatLabel(color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14));
    //会员图标
    private lazy var vipView:UIImageView = {
        let vi = UIImageView(image: UIImage(named: "avatar_vip"))
        return vi
    }()
    //时间
    private lazy var timeLabel:UILabel = UILabel.creatLabel(color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14));

    //来源
    private lazy var sourceLabel:UILabel =  UILabel.creatLabel(color: UIColor.darkGray, font: UIFont.systemFont(ofSize: 14));
   
   

}
