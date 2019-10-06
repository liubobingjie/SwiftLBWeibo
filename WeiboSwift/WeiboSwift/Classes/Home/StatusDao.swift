//
//  StatusDao.swift
//  WeiboSwift
//
//  Created by mc on 2019/9/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class StatusDao: NSObject {
    class func loadStatues(since_id: Int,max_id: Int,finished:@escaping ([[String:Any]]?,_ error:NSError?)->()){
       //从本地数据库中去
        loadcacheStatus(since_id: since_id, max_id: max_id) { (array:[[String : Any]]?) in
            
            let error = NSError()
            //判断本地是否有数据
            if !array!.isEmpty {
               finished(array,nil)
            }else{
                 //从网络获取 存本地
                
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
                    let resultArray = resultModel["statuses"] as! [[String : Any]]
                    if !resultArray.isEmpty {
                        cacheStatuses(statuses: resultArray)
                        finished(resultArray,nil)
                    }else{
                        finished(nil,error)
                    }
                    
                  
                  
                }
                
                
                
                
            }
            
            
        }
        
       
        
    }
    class func loadcacheStatus(since_id: Int,max_id: Int,finished:([[String:Any]])->()){
        var sql = "SELECT statusId,statusText,userId FROM T_Statuses"
        
        if since_id > 0 {
            sql = sql + " WHERE statusId > \(since_id)"
        }else if max_id > 0 {
            sql = sql + " WHERE statusId < \(max_id)"
        }
        
       sql = sql + " ORDER BY statusId DESC LIMIT 20 ;"
        
        print(sql)
         var statusees = [[String:Any]]()
        SQLiteManager.sharedSQLiteManager.dbqueue?.inDatabase({ (db) in
            let res = db.executeQuery(sql, withArgumentsIn: [Any]())
           
            while res!.next(){
                let dict = res?.string(forColumn: "statusText")
               // print(dict)
               
                let data = dict?.data(using: String.Encoding.utf8)
                let dic = try!JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
               statusees.append(dic)
            
            }
           // print(statusees)
            finished(statusees)
            
        })
        
    }
    
    class func cacheStatuses(statuses:[[String:Any]]){
        let sql = "INSERT INTO T_Statuses(statusId,statusText,userId) VALUES (?,?,?);"
      
        let useid = UserAccount.loadAccount()?.uid!
        
        SQLiteManager.sharedSQLiteManager.dbqueue?.inTransaction({ (db, rollback) in
            for dict in statuses{
                
                let statusId = dict["id"]!
                let data = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let statusTest = String(data: data, encoding: String.Encoding.utf8)
                
                var argument:[Any] = [Any]()
                argument.append(statusId)
                argument.append(statusTest!)
                argument.append(useid!)
                if !db.executeUpdate(sql, withArgumentsIn:argument){
                    rollback.pointee = true
                }
            }
            
        })
        
    }

}
