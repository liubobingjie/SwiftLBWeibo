//
//  SQLiteManager.swift
//  WeiboSwift
//
//  Created by mc on 2019/9/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FMDB

public class SQLiteManager: NSObject {
    private static let instance:SQLiteManager = SQLiteManager()
    
    class var sharedSQLiteManager:SQLiteManager{
        return instance
    }
    //创建数据库对象
    var dbqueue:FMDatabaseQueue?
    
   public func openDB(dbName: String){
        let path = dbName.docDir()
        print(path)
        dbqueue = FMDatabaseQueue(path: path)
        //创建表
        createTable()
    }
    
    private func createTable(){
        let sql = "CREATE TABLE IF NOT EXISTS T_Statuses("
            + "statusId integer PRIMARY KEY AUTOINCREMENT," +
            "statusText text NOT NULL," +
            "userId integer" + ");"
        dbqueue?.inDatabase({ (db:FMDatabase) in
           if db.executeUpdate(sql, withArgumentsIn: [Any]()){
               print("建表成功")
            }
           else{
             print("建表失败")
            }
        })
        
    }
    

}
