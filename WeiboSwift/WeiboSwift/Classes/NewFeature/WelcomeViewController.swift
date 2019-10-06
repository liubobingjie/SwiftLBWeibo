//
//  WelcomeViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/20.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit


class WelcomeViewController: UIViewController {
    
    let XMGRootViewControllerSwitchNotification = "XMGRootViewControllerSwitchNotification"

    override func viewDidLoad() {
        super.viewDidLoad()
       setupUI()
        
        
        if let iconUrlStr = UserAccount.loadAccount()?.avatar_large{
           //let arraySubstrings: [Substring] = iconUrlStr.split(separator: "?")
            print(iconUrlStr)
           
             iconView.kf.setImage(with:URL(string: "http://tvax1.sinaimg.cn/crop.111.25.277.277.180/005QzqYCly8g63lr034pij30dw095t9q.jpg?Expires=1566224696&ssig=p%2BtjL%2BQkuW&KID=imgbed,tva"))
        }
    }
    /**
     初始化UI
     */
    private func setupUI(){
        view.addSubview(bgImageView)
        view.addSubview(iconView)
        view.addSubview(message)
        
        bgImageView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
           make.top.equalToSuperview().offset(100)
            
        }
        
        message.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(20)
             make.centerX.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-100)
//            make.height.equalTo(44)
//            make.width.equalTo(100)
//            make.left.equalTo(30)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 2, animations: {
            self.loadViewIfNeeded()
        }) { (_) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.XMGRootViewControllerSwitchNotification), object: true, userInfo: nil)
        }
        
        
    }
    
    // MARK: - 懒加载
    /// 背景图片
    private lazy var bgImageView: UIImageView = UIImageView(image:UIImage(named:"ad_background"))
    ///  头像
    private lazy var iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "ic"))
        iv.layer.cornerRadius = 50
        iv.layer.masksToBounds = true
        return iv
    }()
    /// 消息文字
    private lazy var message: UILabel = {
        let label = UILabel()
        label.text = "欢迎归来"
        //label.alpha = 0.0
        label.sizeToFit()
        return label
    }()

  

}
