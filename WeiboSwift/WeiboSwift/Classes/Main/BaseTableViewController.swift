//
//  BaseTableViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/14.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController,VisitorViewDelegate {
      @objc func loginBtnWillClick() {
       // print("loginBtnWillClick")
        let oauthVC = OAuthViewController()
        let nav = UINavigationController(rootViewController: oauthVC)
        present(nav,animated: true,completion: nil)
        
    }
    
    @objc func registBtnWillClick() {
          //print("registBtnWillClick")
        print(UserAccount.loadAccount() ?? nil!)
    }
    
    var visitorView:VisitorView?
      var userLogin = UserAccount.islogin()
    override func loadView() {
        
        userLogin ? super.loadView() : setupViewtor()
       
    }
    private func setupViewtor(){
        let customView = VisitorView()
        customView.backgroundColor = UIColor.white
        customView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItem.Style.plain, target: self, action: #selector(BaseTableViewController.registBtnWillClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItem.Style.plain, target: self, action: #selector(BaseTableViewController.loginBtnWillClick))
        
        view = customView;
        visitorView = customView
        
        //设置f导航条内容
//        navigationController?.navigationBar.tintColor = UIColor.orange
        
       
    }
}
