//
//  MainViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/12.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.orange
        /*
        let home = HomeViewController()
        home.tabBarItem.image = UIImage(named: "tabbar_home")
        home.tabBarItem.selectedImage = UIImage(named: "tabbar_home_highlighted")
        home.tabBarItem.title = "首页"
        let nav = UINavigationController()
        home.navigationItem.title = "首页"
        nav.addChild(home)
        addChild(nav)
     */
        //获取本地文件json数据
        let path = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil)
        if let jsonPath = path {
            let jsonData = NSData(contentsOfFile: jsonPath)
            do{
                let dicArr = try JSONSerialization.jsonObject(with: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                //print(dicArr)
                for dict in dicArr as![[String: String]]
                {
                  addChildcontView(dict["vcName"]!, title: dict["title"]!, imageName: dict["imageName"]!)

                }


            }catch{
              print(error)
                
                
            }


        }
        
//        addChild(HomeViewController(), title: "首页", imageName: "tabbar_home")
//        addChild(MessageViewController(), title: "消息", imageName: "tabbar_message_center")
//        addChild(DiscoverViewController(), title: "广场", imageName: "tabbar_discover")
//        addChild(ProfileViewController(), title: "我", imageName: "tabbar_profile")
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //添加加号按钮
        setupComposeBtn()
    }
    private func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        let width = UIScreen.main.bounds.size.width / CGFloat(viewControllers!.count)
        let rect = CGRect(x: 0, y: 0, width: width, height: 49)
       let rectofset =  rect.offsetBy(dx: 2 * width, dy: 0)
        composeBtn.frame = rectofset
       // composeBtn.frame = CGRectOffset(rect,2 * width,0)
        
        
        
    }
    
    private func addChildcontView(_ childController: String,title:String,imageName:String){
        //获取动态的命名空间
                let ns:String =  Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
                let vcCls:AnyClass? = NSClassFromString(ns + "." + childController)
                let vcClass = vcCls as! UIViewController.Type
                let vc = vcClass.init()
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        vc.tabBarItem.title = title
        let nav = UINavigationController()
        vc.navigationItem.title = title
        nav.addChild(vc)
        addChild(nav)
        
        
    }
    //
    private func addChild(_ childController: UIViewController,title:String,imageName:String) {
      
        
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        childController.tabBarItem.title = title
        let nav = UINavigationController()
        childController.navigationItem.title = title
        nav.addChild(childController)
        addChild(nav)
        
    }
    
    //MARK: -懒加载
    private lazy var composeBtn = { () -> UIButton in
      let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: UIControl.State.normal)
        btn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControl.State.highlighted)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: UIControl.State.normal)
        btn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControl.State.highlighted)
       // btn.addTarget(self, action:#selector(MainViewController.composeBtnClick), for: UIControl.Event.touchUpInside)
        
        btn.addTarget(self, action: #selector(MainViewController.composeBtnClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    @objc public func composeBtnClick(){
       // print("点击了composeBtnClick")
        let vc = ComposeViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav,animated: true,completion: nil)
    }
    

   

}
