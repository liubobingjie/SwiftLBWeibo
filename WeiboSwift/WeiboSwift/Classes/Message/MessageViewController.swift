//
//  MessageViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/12.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Kingfisher

class MessageViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if !userLogin {
            visitorView?.setupVisitorInfo(isHome: false, imageName: "visitordiscover_image_message", message: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }
        view.addSubview(imageViewTest)
       // imageViewTest.kf.setImage(with: "http://pic-bucket.ws.126.net/photo/0005/2019-08-17/EMQBTBAV00D80005NOS.jpg" as! Resource);
        imageViewTest.kf.setImage(with:URL(string: "http://pic-bucket.ws.126.net/photo/0005/2019-08-17/EMQBTBAV00D80005NOS.jpg"))
        
        
       
    }
    
    lazy var imageViewTest:UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 100, y: 80, width: 100, height: 100)
        return imageView
        
    }()

   

}
