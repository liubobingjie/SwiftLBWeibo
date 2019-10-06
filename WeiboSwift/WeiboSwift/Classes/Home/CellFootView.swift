//
//  CellFootView.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class CellFootView: UIView {
    
    var height:CGFloat? = 0
    
    private let width = UIScreen.main.bounds.size.width
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        addSubview(retweetBtn)
        addSubview(unlikeBtn)
        addSubview(commonBtn)
        
        retweetBtn.snp.makeConstraints { (make) in
            make.width.equalTo(width/3)
            make.left.equalToSuperview()
            // make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        unlikeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(width/3)
            make.left.equalTo(self.retweetBtn.snp.right)
            // make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        commonBtn.snp.makeConstraints { (make) in
            make.width.equalTo(width/3)
            make.left.equalTo(self.unlikeBtn.snp.right)
            // make.top.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        
    }
    //Mark:
    private lazy var retweetBtn:UIButton = UIButton.creatButton(imageName:"timeline_icon_retweet", title:" 转发")
    private lazy var unlikeBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "timeline_icon_unlike"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "timeline_icon_like"), for: UIControl.State.highlighted)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        btn.setTitle(" 赞", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.setTitleColor(UIColor.darkText, for: UIControl.State.normal)
        btn.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: UIControl.State.normal)
        return btn
    }()
    
    private lazy var commonBtn = UIButton.creatButton(imageName:"timeline_icon_comment", title:" 评论")

   

}
