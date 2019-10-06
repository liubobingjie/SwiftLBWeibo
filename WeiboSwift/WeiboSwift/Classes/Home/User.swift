//
//  User.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class User: NSObject {
    
    /// 用户代号
   @objc var id: Int = 0
    /// 友好显示名称
   @objc var name: String?
    /// 用户头像地址（中图），50×50像素
   @objc var profile_image_url: String?
    
    /// 时候是认证, true是, false不是
   @objc var verified: Bool = false
    /// 用户的认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    @objc var verified_type: Int = -1{
        didSet{
            switch verified_type {
            case 0:
                 verified_img = UIImage(named:"avatar_vip")
            case 2,3,5:
                verified_img = UIImage(named:"avatar_enterprise_vip")
            case 220:
                  verified_img = UIImage(named:"avatar_grassroot")
            default:
                  verified_img = nil
            }
        }
    }
    
    /// 认证图标
    @objc var verified_img: UIImage?
    
    /// 头像 URL
   @objc var imageURL: NSURL?
    
    /// 会员等级 1~6
    @objc var mbrank: Int = -1{
        didSet{
            if mbrank > 0 && mbrank < 7 {
                memberImage = UIImage(named: "common_icon_membership_level"+"\(mbrank)")
            }
        }
    }
    /// 会员图像
   @objc var memberImage: UIImage?
    
     static let properties = ["id", "name", "profile_image_url", "verified", "verified_type"]
    //字典转模型
    init(dict:[String:Any]){
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String{
        return "\(self.dictionaryWithValues(forKeys:User.properties))"
    }

}
