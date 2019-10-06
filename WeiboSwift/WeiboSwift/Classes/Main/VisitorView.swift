//
//  VisitorView.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SnapKit

protocol VisitorViewDelegate: NSObjectProtocol{
    //登录回调
    func loginBtnWillClick()
    //注册回调
    func registBtnWillClick()
}

class VisitorView: UIView {
    
    weak var delegate:VisitorViewDelegate?
    
    public func setupVisitorInfo(isHome:Bool,imageName:String,message:String)
    {
        iconView.isHidden = !isHome
        homeIcon.image = UIImage(named: imageName)
        messageLabel.text = message
        if isHome
        {
            startAnimation()
        }
        
    }
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
         //添加子控件
        addSubview(iconView)
        addSubview(makeBGView)
        addSubview(homeIcon)
        addSubview(messageLabel)
        addSubview(loginBtton)
        addSubview(registerBtton)
        //布局背景
        iconView.snp.makeConstraints { (make) in
            //make.size.equalTo(100)
            make.center.equalToSuperview()
        }
        //设置小房子
        homeIcon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        //设置文本
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom)
            make.width.equalTo(224)
            //make.centerX.equalTo(iconView.snp.centerX)
            make.centerX.equalTo(iconView)
           
           // make.right.equalTo(self).offset(-50)
           // make.left.equalTo(self).offset(50)
        }
        //设置按钮
        loginBtton.snp.makeConstraints { (make) in
           make.left.equalTo(messageLabel.snp.left)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
        }
        registerBtton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.left.equalTo(loginBtton.snp.right).offset(20)
            make.top.equalTo(loginBtton.snp.top)
           // make.centerY.equalTo(loginBtton.snp_centerWithinMargins)
        }
        //设置蒙版
        makeBGView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --设置动画
    private func startAnimation()
    {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.duration = 20
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        iconView.layer.add(anim, forKey: nil)
        
        
    }
    //MARK: -懒加载
    private lazy var iconView:UIImageView = {
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        return iv
    }()
    private lazy var homeIcon:UIImageView = {
        let iv = UIImageView(image:UIImage(named: "visitordiscover_feed_image_house"))
        return iv
    }()
    private lazy var messageLabel:UILabel = {
        let label = UILabel()
        label.text = "还未登录呢"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.left
        return label
    }()
    ///登录
    private lazy var loginBtton:UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
       // btn.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(VisitorView.loginBttonClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    ///注册
    private lazy var registerBtton:UIButton = {
        let btn = UIButton()
        btn.setTitle("注册", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.orange, for: UIControl.State.normal)
       // btn.setTitleColor(UIColor.red, for: UIControl.State.highlighted)
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(VisitorView.registerBttonClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    // 遮挡图片
    private lazy var makeBGView:UIImageView = {
        let vc = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return vc
    }()
    
    @objc public func registerBttonClick()
    {
        //print("registerBttonClick")
        delegate?.registBtnWillClick()
    }
    @objc public func loginBttonClick()
    {
       delegate?.loginBtnWillClick()
        // print("loginBttonClick")
    }
    
}
