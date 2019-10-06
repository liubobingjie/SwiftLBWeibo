//
//  Status.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/23.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Kingfisher

class Status: NSObject{
    ///微博的创建时间
    @objc var created_at:String?{
        didSet{
            if let time = created_at{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
                formatter.locale = NSLocale(localeIdentifier: "en") as Locale
               
                let date = formatter.date(from: time)! as Date
                
                 created_at = date.dateDesctiption
                
            }
        }
    }
    //微博ID
   @objc var id:Int = 0
    //微博内容
   @objc var text:String?
    
    @objc var source:String?{
        didSet{
            //截取字符串
            if let str = source
            {
                if str.isEmpty{
                    return
                }
                let startLocation = (str as NSString).range(of: ">").location + 1
                let lenth = (str as NSString).range(of: "<", options: NSString.CompareOptions.backwards).location - startLocation
                source = "来自：" + (str as NSString).substring(with: NSMakeRange(startLocation, lenth))
            }
        }
    }
    //配图数组
    @objc var pic_urls:[[String:Any]]?{
        didSet{
            stotedPicUrls = [URL]()
            storedLargePicURLS = [URL]()
            for dict in pic_urls!{
                if let urlStr = dict["thumbnail_pic"] as? String {
                    
                    stotedPicUrls?.append(URL(string: urlStr)!)
                    //处理大图
                    let largeURLStr = urlStr.replacingOccurrences(of: "thumbnail", with: "large")
                  
                    storedLargePicURLS?.append(URL(string: largeURLStr)!)
                    
                }
                
            }
        }
    }
     var stotedPicUrls:[URL]?
    
    var storedLargePicURLS:[URL]?
    //用户信息
    @objc var user:User?
    
   @objc var retweeted_status: Status?
    
    
    /// 定义一个计算属性, 用于返回原创获取转发配图的URL数组
    var pictureURLS:[URL]?{
        
        if retweeted_status != nil {
            return retweeted_status?.stotedPicUrls
        }else{
            return stotedPicUrls
        }
       
    }
    
    var LargePictureURLS:[URL]?
    {
       
            if retweeted_status != nil {
               return retweeted_status?.storedLargePicURLS
            }else{
              return storedLargePicURLS
            }

    }
    
   static let properties = ["created_at","id","text","source","pic_urls"]
    override var description: String{
       let dict = dictionaryWithValues(forKeys: Status.properties)
        return "\(dict)"
    }
   
    
    init(dict:[String:Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "user" {
            user = User(dict: value as! [String:Any])
           
            return
        }
        
        if key == "retweeted_status" {
            retweeted_status = Status(dict: value as! [String : Any])
            return
        }
        
        super.setValue(value, forKey: key)
    }
   
    
    //加载微博数据
    class public func loadStatus(since_id: Int,max_id: Int, finished:@escaping (_ modeles:[Status]?,_ error:NSError?)->()){
        
        StatusDao.loadStatues(since_id: since_id, max_id: max_id) { (array:[[String : Any]]?,error:NSError?) in
            
            if array == nil {
                finished(nil,error)
                return
            
        }
            if error != nil
            {
                 finished(nil,error)
                return
            }
            
           // finished(array,nil)
            let models = dict2Model(list: array!)
        cacheStatusImages(models: models, finished: finished)
            
        }
        /*
        var parmeter = ["access_token":UserAccount.loadAccount()?.access_token];
       
        if since_id > 0
        {
             parmeter["since_id"] = "\(since_id)"
        }
        // 上拉刷新
        if max_id > 0
        {
            parmeter["max_id"] = "\(max_id - 1)"
        }
        
        
        
        HttpsTool.requesData(URLString: "https://api.weibo.com/2/statuses/home_timeline.json", type: MethodType.get, parmeters: parmeter as![String:String]) { (result:Any) in
            
            let resultModel = result as![String:Any]
            
            StatusDao.cacheStatuses(statuses: resultModel["statuses"] as! [[String : Any]])
            
          let models = dict2Model(list: resultModel["statuses"] as! [[String : Any]])
            if models.count > 0 {
                 //缓存微博配图
                cacheStatusImages(models: models, finished: finished)
               //finished(models,nil)
            }
        }
 */
        
    }
    
    class func cacheStatusImages(models:[Status],finished:@escaping (_ modeles:[Status],_ error:NSError?)->()){
        
        if models.count == 0 {
            finished(models,nil)
            return
        }
        
        let group = DispatchGroup()
        
        for status in models {
            if (status.pic_urls?.count)! > 0
            {
                for imageUrlStr in  status.stotedPicUrls!
                {
                    group.enter()
                    //缓存图片
                    // print("abc".cacheDir())
                    KingfisherManager.shared.downloader.downloadImage(with: imageUrlStr, retrieveImageTask: RetrieveImageTask?.none, options:nil, progressBlock: nil) { (_, _, _, _) in
                        //print("ok")
                        group.leave()
                    }
                    
                }
                
                
            }
           
        }
        
        // 监听所有缓存操作的通知
        group.notify(queue: dispatch_queue_main_t.main) {
             print("queuebo")
             finished(models,nil)
        }
       
        
    }
    
    class public func dict2Model(list:[[String:Any]])->[Status] {
        var models = [Status]()
        
        for dict in list{
            models.append(Status(dict: dict))
        }
        return models
        
    }
    
   
    

   
}
