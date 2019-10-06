//
//  HomeViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/12.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

public let ReuseId = "ReuseIdentifier"

class HomeViewController: BaseTableViewController {
    
    /// 定义变量记录当前是上拉还是下拉
    var pullupRefreshFlag = false
    //用于保存微博的数组
    var statuses:[Status]?{
        didSet{
            //设置数据完成后刷新表格
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //是否登录，未登录展示对应的消息
        if !userLogin {
            visitorView?.setupVisitorInfo(isHome: true, imageName: "visitordiscover_feed_image_house", message: "关注一些人，回这里看看有什么惊喜")
            
            return
        }
        //MARK: -初始化导航条
        setupNav()
        //MARK:-注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(showBtn), name: NSNotification.Name(rawValue: XMGPopoverAnimatorShowNotification), object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(dissBtn), name: NSNotification.Name(rawValue: XMGPopoverAnimatorDismissNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrow), name: NSNotification.Name(rawValue: StatusPictureViewSelected), object: nil)
        
        //注册cell
        
        tableView.register(StatusForwardViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentfiler.ForwardCell.rawValue)
        
        tableView.register(StatusNormalViewCell.self, forCellReuseIdentifier: StatusTableViewCellIdentfiler.NormalCell.rawValue)
        // tableView.register(StatusForwardViewCell.self, forCellReuseIdentifier: ReuseId)
        
        tableView.estimatedRowHeight = 200
        //tableView.rowHeight = 300
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        //设置刷新
        refreshControl = HomeRefreshViewControl()
        refreshControl?.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        //self.refreshControl = refreshControl
        
        //加载微博数
        loadData()
       
        
    }
    @objc public func showPhotoBrow(notify:NSNotification){
        
       // print(notify.userInfo)
        guard let indexPath = notify.userInfo?[StatusPictureViewIndexKey] else{
            return;
        }
        guard let urls = notify.userInfo?[StatusPictureViewURLsKey] else {
            return
        }
        
        let index = (indexPath as! IndexPath).item
        let urlsPic = urls as! [URL]
        
        print(index)
        let vc = PhotoBrowViewController(index: index, urls: urlsPic)
    
        
        present(vc, animated: true, completion: nil)
        
        
        
        
    }
    
    @objc public func loadData(){
        var since_id = statuses?.first?.id ?? 0
        
        var max_id = 0
        
        if pullupRefreshFlag {
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        
        Status.loadStatus(since_id: since_id,max_id: max_id){ (models, error) in
            
            self.refreshControl?.endRefreshing()
            if error != nil {
                return
            }
            if since_id > 0 {
                 self.statuses = models! + self.statuses!
                self.showNewStatusCount(count: models!.count)
                
            }else if max_id > 0{
                self.statuses = self.statuses! + models!
            }
            
            
            else{
                 self.statuses = models
            }
            
           
        }
        
        
    }
    
    private func showNewStatusCount(count : Int){
        newStatusLabel.isHidden = false
        newStatusLabel.text = (count == 0) ? "没有刷新到新的微博数据" : "刷新到\(count)条微博数据"
        UIView.animate(withDuration: 2, animations: {
            self.newStatusLabel.transform = CGAffineTransform(translationX: 0, y: self.newStatusLabel.frame.height)
        }) { (_) in
            
            UIView.animate(withDuration: 2, animations: {
                self.newStatusLabel.transform = .identity
            }, completion: { (_) in
                self.newStatusLabel.isHidden = true
            })
        
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc public func showBtn(){
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.isSelected = !titleBtn.isSelected
    }
    @objc public func dissBtn(){
        let titleBtn = navigationItem.titleView as! TitleButton
        titleBtn.isSelected = !titleBtn.isSelected
        
    }
    private func setupNav()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatBarButtonItem(imageName: "navigationbar_friendattention", target: self, action:#selector(HomeViewController.leftButtonClick))
         navigationItem.rightBarButtonItem = UIBarButtonItem.creatBarButtonItem(imageName: "navigationbar_pop", target: self, action:#selector(HomeViewController.rightButtonClick))

        //MARK:-初始化标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("风云悟道 ", for: UIControl.State.normal)
       
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick), for: UIControl.Event.touchUpInside)
        navigationItem.titleView = titleBtn
        
        
    }
    @objc public func titleBtnClick(btn:TitleButton){
        //btn.isSelected = !btn.isSelected
        //弹出caid
        let sb = UIStoryboard(name: "PopoverViewController", bundle: nil)
        let popover = sb.instantiateInitialViewController() as! PopoverViewController
        //设置专场代理
        popover.transitioningDelegate = popverAnimator
        popover.modalPresentationStyle = UIModalPresentationStyle.custom
        present(popover, animated: true, completion: nil)
    
    }
    @objc public func leftButtonClick()
    {
        print("leftButtonClick")
    }
    @objc public func rightButtonClick()
    {
       // print("rightButtonClick")
        
        //真机可以调试扫描二维码
//        let sb = UIStoryboard(name: "QRCodeViewController", bundle: nil)
//        let vc = sb.instantiateInitialViewController()
//        present(vc!,animated: true,completion: nil)
        //查看我的二维码
       
        //present( QRcodeCardController(),animated: true,completion: nil)
        let vc = QRcodeCardController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private lazy var popverAnimator:PresentAnmator = {
        let pa  = PresentAnmator()
        return pa
    }()
    //刷新控件提醒
    private lazy var newStatusLabel:UILabel = {
        let label = UILabel()
        let heght:CGFloat = 44
        label.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: heght)
        label.backgroundColor = UIColor.orange
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        
        self.navigationController?.navigationBar.insertSubview(label, at: 0)
        
        label.isHidden = true
        
        return label
    }()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        rowCache.removeAll()
    }
    
    //行高缓存
    fileprivate var rowCache:[Int :CGFloat] = [Int :CGFloat]()
  

}



extension HomeViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let status = self.statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier:StatusTableViewCellIdentfiler.cellID(status: status) , for: indexPath) as! StatusTableViewCell
        
       cell.status = status
        
       let count = statuses?.count ?? 0
        if indexPath.row == (count - 1){
            pullupRefreshFlag = true
            loadData()
        }
        
        //cell.textLabel?.text = status.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let status = self.statuses![indexPath.row]
        if let height = rowCache[status.id] {
            return height
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier:StatusTableViewCellIdentfiler.cellID(status: status)) as! StatusTableViewCell
        
        let rowHeight = cell.rowHeight(stutas: status)
        
        rowCache[status.id] = rowHeight
        return rowHeight
    }
}

