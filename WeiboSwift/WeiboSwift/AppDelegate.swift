//
//  AppDelegate.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/12.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

/// 视图控制器切换通知字符串

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let XMGRootViewControllerSwitchNotification = "XMGRootViewControllerSwitchNotification"

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        
           //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.switchRootController), name: NSNotification.Name(rawValue: XMGRootViewControllerSwitchNotification), object: nil)
        
        print(UserAccount.loadAccount() ?? "暂时没有值")
       window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = defautsController()
        //window?.rootViewController = OAuthViewController()
        window?.makeKeyAndVisible()
        
        SQLiteManager.sharedSQLiteManager.openDB(dbName: "statuses.sqlite")
        return true
    }
    //
    @objc public func switchRootController(notify:Notification){
        
        if notify.object as! Bool {
             window?.rootViewController = MainViewController()
        }else{
             window?.rootViewController = WelcomeViewController()
        }
        
       
    }
    private func defautsController()->UIViewController{
        if UserAccount.islogin() {
           return isNewUpdate() ? NewFeatureViewController(): WelcomeViewController()
        }
        
        return MainViewController()
    }
    
    private func isNewUpdate() -> Bool{
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
       let sandboxVersion = UserDefaults.standard.object(forKey: "CFBundleShortVersionString") as? String ?? ""
        if currentVersion.compare(sandboxVersion) == ComparisonResult.orderedDescending {
            UserDefaults.standard.set(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        
        return false
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

