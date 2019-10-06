//
//  UserAccount.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class UserAccount: NSObject,NSCoding{
    //access_token的生命周期，单位是秒数。
    var expires_date:Date?
    //用户授权的唯一票据
  @objc public var access_token:String?
    //access_token的生命周期，单位是秒数。
    @objc var expires_in:NSNumber?{
        didSet{
            expires_date = NSDate(timeIntervalSinceNow: expires_in!.doubleValue) as Date
        }
    }
    //授权用户的UID
    @objc var uid:String?
    //用户的名称
    @objc var screen_name:String?
    //用户的头像
    @objc var avatar_large:String?

    
    init(dict:[String:Any])
    {
        super.init()
       setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String{
        return  dictionaryWithValues(forKeys: ["access_token","expires_in","uid","avatar_large","screen_name"]).description
    }
    //MARK:->归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
    
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_in = aDecoder.decodeObject(forKey: "expires_in") as? NSNumber ?? 0
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
        
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
    }
    //保存模型
    public func saveAccount(){
        //let path  = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).last!
        let filePath = "account.plist".docDir()
        NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    static var accountUser:UserAccount?
   class func loadAccount()->UserAccount?{
        //let path  = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, .userDomainMask, true).last!
   //判断是否加载过
    if (accountUser != nil) {
        return accountUser
    }
    //加载授权模型
          let filePath = "account.plist".docDir()
        accountUser  = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount
    
    //判断是否过期
    if (accountUser?.expires_date?.compare(Date())) == ComparisonResult.orderedAscending
    {
        return nil
    }
    
    return accountUser ?? nil
    }
    //是否登录
    class public func islogin() ->Bool {
        return UserAccount.loadAccount() != nil
    }
    
    //MARK:->获取用户信息
    public func loadUserInfo(finished:@escaping (_ account:UserAccount?,_ error:NSError?)->()){
        if access_token == nil{
            return
        }
        let path = "https://api.weibo.com/2/users/show.json"
        let parmenter = ["access_token":access_token,"uid":uid]
        HttpsTool.requesData(URLString: path, type: .get, parmeters: parmenter as! [String : String]) { (result:Any) in
            
            //print(result)
            if let dict = result as? [String : Any]
            {
                self.screen_name = dict["screen_name"] as? String
                self.avatar_large = dict["avatar_large"] as? String
                //保存
               // self.saveAccount()
                
                finished(self,nil)
                return
            }
           
            finished(nil,nil)
            
        }
    }
    
}
