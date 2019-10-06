//
//  ProfileViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/12.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ProfileViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !userLogin {
            visitorView?.setupVisitorInfo(isHome: false, imageName: "visitordiscover_image_profile", message: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
            return
        }
       
    }

    
}
