//
//  ComposeViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/31.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SnapKit
/// 发布微博的最大长度
private let XMGStatusTextMaxLength = 10
class ComposeViewController: UIViewController {
    
    /// 工具条底部约束
    var toolbarBottonCons: Constraint?
     var picViewHeightCons: Constraint?
    
    var isshow:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        //注册通知监听键盘弹出
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChange), name: UIResponder.keyboardWillChangeFrameNotification , object: nil)
       setupNav()
        //
        setupTextView()
        setupPhotoview()
        //初始化工具条
        setuptoolbar()
        //当前控制器的自控制器
        addChild(emotionView)
        addChild(photoSelectorVC)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if photoSelectorVC.view.bounds.height == 0{
            textView.becomeFirstResponder()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        textView.resignFirstResponder()
    }
    
    
    @objc func keyboardChange(notify:Notification){
        
       // print(notify)
        
        let value = notify.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue
        let rect = value.cgRectValue
        
        print(rect.height)
        UIView.animate(withDuration: 0.25) {
          self.toolbarBottonCons?.update(offset: -(UIScreen.main.bounds.height - rect.origin.y))
        }
        
       
        
    }
  
    
   
    private func  setupTextView(){
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(5)
            
        }
        
    }
    private func setuptoolbar()
    {
        view.addSubview(toolBar)
        var items = [UIBarButtonItem]()
        
       //添加图片toolbar
      let itempic = UIBarButtonItem(image: UIImage(named:"compose_toolbar_picture"), style: UIBarButtonItem.Style.done, target: self, action: #selector(selectPicture))
        items.append(itempic)
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
        
        let itemmentionbutton = UIBarButtonItem(image: UIImage(named:"compose_mentionbutton_background"), style: UIBarButtonItem.Style.done, target: nil, action: nil)
        items.append(itemmentionbutton)
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
        
        let itemmentrendbutton = UIBarButtonItem(image: UIImage(named:"compose_trendbutton_background"), style: UIBarButtonItem.Style.done, target: nil, action: nil)
        items.append(itemmentrendbutton)
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
        
        let inputEmoticon = UIBarButtonItem(image: UIImage(named:"compose_emoticonbutton_background"), style: UIBarButtonItem.Style.done, target: self, action: #selector(ComposeViewController.inputEmoticon))
        items.append(inputEmoticon)
        items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
        
        let addbutton = UIBarButtonItem(image: UIImage(named:"compose_addbutton_background"), style: UIBarButtonItem.Style.done, target: nil, action: nil)
        items.append(addbutton)
        
        //添加字控件
       toolBar.items = items
        
        toolBar.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(44)
            make.left.equalToSuperview()
           self.toolbarBottonCons = make.bottom.equalToSuperview().constraint
        }
        view.addSubview(lengthTipLabel)
        lengthTipLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.toolBar.snp.right).offset(-10)
            make.top.equalTo(self.toolBar.snp.top).offset(-20)
        }
        
        
        
    }
    func setupPhotoview(){
        view.insertSubview(photoSelectorVC.view, belowSubview: toolBar)
        photoSelectorVC.view.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
           picViewHeightCons = make.height.equalTo(0).constraint
            
        }
        
    }
    
    @objc func selectPicture(){
       // print("selectPicture")
        textView.resignFirstResponder()
        //self.isshow = false
        picViewHeightCons?.update(offset: UIScreen.main.bounds.height * 0.5)
        
    }
    @objc func inputEmoticon(){
         //print("inputEmoticon")
        textView.resignFirstResponder()
        textView.inputView = (textView.inputView == nil) ? emotionView.view : nil
        textView.becomeFirstResponder()
       
    }
    private func  setupNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItem.Style.done, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItem.Style.done, target: self, action: #selector(send))
        navigationItem.rightBarButtonItem?.isEnabled = false
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
        let label1 = UILabel()
        label1.text = "发送微博"
        label1.font = UIFont.systemFont(ofSize: 13)
        label1.textColor = UIColor.orange
        label1.sizeToFit()
        titleView.addSubview(label1)
        let label2 = UILabel()
        label2.text = UserAccount.loadAccount()?.screen_name
        label2.font = UIFont.systemFont(ofSize: 11)
        label2.sizeToFit()
        titleView.addSubview(label2)
        navigationItem.titleView = titleView
        label2.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        label1.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            
        }
        
    }
    //懒加载
    private lazy var textView:UITextView = {
        let tv = UITextView()
        tv.delegate = self
        return tv
    }()
    //懒加载j表情键盘
    private lazy var emotionView:UIViewController = EmoticonViewController {[weak self] (emoticon:Emoticon) in
        self?.textView.insetEmoticon(emoticon: emoticon, font: 20)
        
    }
     //懒加载图片选择器
    private lazy var photoSelectorVC:PhotoSeletorController = PhotoSeletorController()
    
    private lazy var placeholderLabel:UILabel = {
        let label = UILabel()
        label.text = "分享新鲜事...."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        return label
    }()
    /// 长度提示标签
    private lazy var lengthTipLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "\(XMGStatusTextMaxLength)"
        return label
    }()
    
    private lazy var toolBar:UIToolbar = UIToolbar()
    
    @objc func close(){
        dismiss(animated: true, completion: nil)
    }
    @objc func send(){
        //s发送微博
        //"Insufficient app permissions!"对应申请key的时候没有这个接口权限
        
        
        let text = self.textView.emoticonAttributedText()
        if text.count > XMGStatusTextMaxLength{
            print("输入内容过长")
            return
        }
        
        if let image = photoSelectorVC.pictureImages.last {
             let path = "授权的上传url"
             let params = ["access_token":UserAccount.loadAccount()!.access_token! , "status": textView.emoticonAttributedText()]
            HttpsTool.uploadImage(URLString: path, image: image, params: params, success: { (result:Any) in
                print(result)
            }) { (_) in
                print("error")
                }
            
        }else{
            
            let path = "https://api.weibo.com/2/statuses/update.json"
            let params = ["access_token":UserAccount.loadAccount()!.access_token! , "status": textView.emoticonAttributedText()]
            HttpsTool.requesData(URLString: path, type: MethodType.post, parmeters: params as![String:String]) { (result:Any) in
                print(result)
            }
        }
        
        
        
    }

}
extension ComposeViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        
        let len = XMGStatusTextMaxLength - textView.emoticonAttributedText().count
        print(len)
        lengthTipLabel.text = (len == XMGStatusTextMaxLength) ? "" : String(len)
        lengthTipLabel.textColor = len >= 0 ? UIColor.lightGray : UIColor.red
    }
}
