//
//  DiscoverViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/12.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseTableViewController {
    var dataArray:[[String:Any]]?
    override func viewDidLoad() {
        super.viewDidLoad()
        if !userLogin {
            visitorView?.setupVisitorInfo(isHome: false, imageName: "visitordiscover_image_message", message: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
            return
        }
        loadData()
      
    }

    

}

extension DiscoverViewController
{
    fileprivate func loadData(){
        HttpsTool.requesData(URLString: "http://c.m.163.com/nc/article/list/T1348649079062/0-20.html", type: MethodType.get, parmeters: nil) { (result:Any) in
            guard let resultDict = result as? [String:Any]else{
                return
            }
            guard let dataArr = resultDict["T1348649079062"] as? [[String:Any]] else{
                return
            }
            //
            self.dataArray = dataArr
            
        }
    }
    
}
