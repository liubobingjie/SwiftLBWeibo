//
//  OAuthViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    // 0. 定义常量
    private let WB_Client_ID = "85208382"
    private let WB_REDIRECT_URI = "http://www.520it.com"
    private let WB_App_Secret = "df82f4eec54593fb2c7d0b05eeeb978c"
    
    let XMGRootViewControllerSwitchNotification = "XMGRootViewControllerSwitchNotification"
    override func loadView() {
        view = webview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "微博登录"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItem.Style.plain, target: self, action: #selector(OAuthViewController.diss))
        
        let urlstr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_Client_ID)&redirect_uri=\(WB_REDIRECT_URI)"
        //print("bobo" + urlstr)
        //let urlstr = "https://api.weibo.com/oauth2/authorize?client_id=85208382&redirect_uri=http://www.520it.com"
        let url = NSURL(string: urlstr)
        let request = NSURLRequest(url:url! as URL)
        webview.loadRequest(request as URLRequest)
       
    }
    
   @objc public func diss(){
    dismiss(animated: true, completion: nil)
        
    }
    
    //MARK:懒加载一个webview
    private lazy var webview: UIWebView = {
        let web = UIWebView()
        web.frame = UIScreen.main.bounds
        web.delegate = self
        return web
    }()

   
}
extension OAuthViewController:UIWebViewDelegate
{
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        print(request.url?.absoluteString ?? "www.baidu.com")
        if !request.url!.absoluteString.hasPrefix(WB_REDIRECT_URI){
            return true
        }
        
        if request.url!.query!.hasPrefix("code="){
           //授权成功
            // 取出已经授权的requetToken
          let code = request.url!.query?.substring(from: "code=".endIndex)
            //print("yanzheng" + code!)
            //利用已经授权的requetToken 换取AccessToken
            loadAccessToken(codestr:code)
            
        }else{
            //取消授权
            diss()
        }
        
        
        return false
    }
    private func loadAccessToken(codestr:String?){
        //封装参数
        let parmenter = ["client_id":"85208382","client_secret":"df82f4eec54593fb2c7d0b05eeeb978c","grant_type":"authorization_code","code":codestr,"redirect_uri":"http://www.520it.com"]
        
        
        HttpsTool.requesData(URLString: "https://api.weibo.com/oauth2/access_token", type: .post, parmeters: parmenter as! [String : String]) { (result:Any) in
            print(result)
            let user = UserAccount.init(dict: result as! [String : Any])
            //print("bobo" + user.access_token! )
            
            //获取用户信息
            //user.loadUserInfo()
            user.loadUserInfo(finished: { (account:UserAccount?, error:NSError?) in
                account?.saveAccount()
                //去
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.XMGRootViewControllerSwitchNotification), object: false, userInfo: nil)
            })
            
           // user.saveAccount()
           // print(UserAccount.description())
        }
        
    }
    
    
    
}
