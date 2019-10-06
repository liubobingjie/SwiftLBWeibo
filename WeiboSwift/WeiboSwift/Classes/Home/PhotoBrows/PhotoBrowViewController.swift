//
//  PhotoBrowViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/31.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

let photoBrowserCellReuseIdentifier = "pictureCell"
class PhotoBrowViewController: UIViewController {
    
    var currentIndex:Int? = 0
    var pictureUrl:[URL]?
    init(index:Int,urls:[URL]) {
        currentIndex = index
        pictureUrl = urls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupUI()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
       
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let pageWidth = UIScreen.main.bounds.width
        let offset = CGPoint(x: CGFloat(currentIndex!) * pageWidth, y: collectionView.contentOffset.y)
        collectionView.setContentOffset(offset, animated: false)
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //loadViewIfNeeded()
       
    }
    
    private func setupUI(){
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        closeBtn.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(100)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        saveBtn.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(100)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.right.left.equalToSuperview()
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCellReuseIdentifier)
      
    
    }
    
  //懒加载
    private lazy var closeBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("关闭", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.backgroundColor = UIColor.darkGray
        btn.addTarget(self, action: #selector(closeVC), for: UIControl.Event.touchUpInside)
        return btn
    }()
    private lazy var saveBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("保存", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.backgroundColor = UIColor.darkGray
         btn.addTarget(self, action: #selector(save), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    private lazy var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserLayout())
    
    
    
    @objc public func closeVC(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc public func save(){
        let index = collectionView.indexPathsForVisibleItems.last!
        let cell = collectionView.cellForItem(at: index) as! PhotoBrowserCell
        let image = cell.iconView.image
        
        UIImageWriteToSavedPhotosAlbum(image!, self,  #selector(savephoto(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    @objc func savephoto(image:UIImage, didFinishSavingWithError:NSError?,contextInfo:AnyObject){
        if didFinishSavingWithError != nil{
            print("保存失败")
            
        }else{
             print("保存成功")
        }
        
    }
    
}

extension PhotoBrowViewController:UICollectionViewDelegate,UICollectionViewDataSource,PhotoBrowserCellDelegate{
    func photoBrowserCellDidClose(cell: PhotoBrowserCell) {
        closeVC()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureUrl?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCellReuseIdentifier, for: indexPath) as! PhotoBrowserCell
        
           cell.imageURL = pictureUrl![indexPath.item]
        cell.photoBrowserCellDelegate = self
        return cell
    }
    
    
}


class PhotoBrowserLayout : UICollectionViewFlowLayout
{
    override func prepare() {
        super.prepare()
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
    }
    
}
