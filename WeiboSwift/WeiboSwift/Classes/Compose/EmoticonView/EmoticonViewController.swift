//
//  EmoticonViewController.swift
//  EmoticonDemo
//
//  Created by mc on 2019/9/1.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
let XMGEmoticonCellReuseIdentifier = "XMGEmoticonCellReuseIdentifier"
class EmoticonViewController: UIViewController {
    
    var emoticonDidSelectedCallBack:(_ emoticon:Emoticon)->()
    
    init(callBack:@escaping (_ emot:Emoticon)->()){
        self.emoticonDidSelectedCallBack = callBack
         super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化ui
        setupUI()

    }
    private func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        //布局子控件
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        let dic = ["collectionView":collectionView,"toolBar":toolBar]
        cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collectionView]-0-|", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: nil, views: dic)
         cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-[toolBar(44)]-0-|", options: NSLayoutConstraint.FormatOptions.init(rawValue: 0), metrics: nil, views: dic)
        
        view.addConstraints(cons)
        
        
    }
    private lazy var collectionView:UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmoticonLayout())
        collection.backgroundColor = UIColor.clear
        collection.register(EmoticonCell.self, forCellWithReuseIdentifier: XMGEmoticonCellReuseIdentifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    private lazy var toolBar:UIToolbar = {
       let toobar = UIToolbar()
        toobar.tintColor = UIColor.darkGray
        var items = [UIBarButtonItem]()
        var index = 0
        for item in ["最近","默认","emoji","浪小花"]{
            let ite = UIBarButtonItem(title: item, style: UIBarButtonItem.Style.done, target: self, action: #selector(itemClick))
            ite.tag = index
            index = index + 1
            items.append(ite)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toobar.items = items
        return toobar
    }()
    
    @objc func itemClick(item:UIBarButtonItem){
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: item.tag), at: UICollectionView.ScrollPosition.left, animated: false)
    }
    private lazy var packages:[EmoticPackage] = EmoticPackage.packageList
   
}
extension EmoticonViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticous?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XMGEmoticonCellReuseIdentifier, for: indexPath) as! EmoticonCell
        //取出对应组
        let package = packages[indexPath.section]
        //取出对应行的模型
        let emoticon = package.emoticous![indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    
    //代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath.item)
        let enction = packages[indexPath.section].emoticous![indexPath.item]
        
        packages[0].appendEmoticons(emoticon: enction)
        enction.times = enction.times + 1
        //collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
        
        emoticonDidSelectedCallBack(enction)
    }
    
    
}
class EmoticonCell: UICollectionViewCell{
    var emoticon:Emoticon?{
        didSet{
            //d判断是图片
            if emoticon?.chs != nil {
                iconBotton.setImage(UIImage(contentsOfFile: emoticon!.imagePath!), for: UIControl.State.normal)
            }else{
                iconBotton.setImage(nil, for: UIControl.State.normal)
            }
            iconBotton.setTitle(emoticon?.emojiStr ?? "", for: UIControl.State.normal)
            
            
            if emoticon!.isRemoveButton {
                iconBotton.setImage(UIImage(named: "compose_emotion_delete"), for: UIControl.State.normal)
                 iconBotton.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: UIControl.State.highlighted)
            }
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUPUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUPUI(){
        contentView.addSubview(iconBotton)
        iconBotton.backgroundColor = UIColor.white
        iconBotton.frame = contentView.bounds.insetBy(dx: 4, dy: 4)
        iconBotton.isUserInteractionEnabled = false
        
    }
    private lazy var iconBotton:UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        return btn
    }()
    
    
    
}
/// 自定义布局
class EmoticonLayout: UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        let width = collectionView!.bounds.width / 7
        itemSize = CGSize(width: width, height: width)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
        let y = (collectionView!.bounds.height - 3 * width) * 0.4
        collectionView?.contentInset =  UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
    }
}
