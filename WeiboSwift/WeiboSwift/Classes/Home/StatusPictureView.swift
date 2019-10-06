//
//  StatusPictureView.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Kingfisher
class StatusPictureView: UICollectionView {
    var status:Status?{
        
        didSet{
            reloadData()
        }
        
    }
     private var layout = UICollectionViewFlowLayout()
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: self.layout)
        register(pictureViewCell.self, forCellWithReuseIdentifier: XMGPictureCellReuseIdentifier)
        backgroundColor = UIColor.white
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        dataSource = self
        delegate = self
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func calculateImageSize(status: Status)->CGSize{
        //取出配图的个数
        self.status = status
        let count = status.stotedPicUrls?.count
        if count == 0 || count == nil{
            return CGSize.zero
        }
        //如果只有一张
        if count == 1 {
            let key = status.stotedPicUrls!.first?.absoluteString
            //let group = DispatchGroup()
            //var image1:UIImage?
            //var image2:UIImage?
            
           //image1 = UIImage()
            
            let image  = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: key!)
            
            self.layout.itemSize = image?.size ?? CGSize.zero
            
             return image?.size ?? CGSize.zero
            
//            KingfisherManager.shared.retrieveImage(with: key!, options: nil, progressBlock: nil) { (image:Image?, _, _, _) in
//                group.enter()
//                if image != nil {
//                    //return (image?.size,image?.size)
//                    image1? = image!
//                    group.leave()
//                }
//
//
//            }
//
//
//
//            group.notify(queue: dispatch_queue_main_t.main) {
//
//                self.layout.itemSize = image1?.size ?? CGSize.zero
//
//
//            }
            
           
            
            
        }
        // 3.四张图片
        let itemSize = CGSize(width: 90, height: 90)
        layout.itemSize = itemSize
        let margin:CGFloat = 10
        if count == 4
        {
            let width = itemSize.width * 2.0 + margin
            
            return CGSize(width: width, height: width)
        }
        
        let colCount = 3
        let rowCount = (count! - 1)/3 + 1
        // 宽度 * 列数 + (列数 - 1) * 间隙
        let width = itemSize.width * CGFloat(colCount) + CGFloat(colCount - 1) * margin
        // 高度 * 行数 + (行数 - 1) * 间隙
        let height = itemSize.height * CGFloat(rowCount) + CGFloat(rowCount - 1) * margin
        
        //如果只有4张
        //如果其他张就按9宫格
        //没有返回zero
        return CGSize(width: width, height: height)
        
    }

}

/// 选中图片的通知名称
public let StatusPictureViewSelected = "StatusPictureViewSelected"
/// 当前选中图片的索引对应的key
public let StatusPictureViewIndexKey = "StatusPictureViewIndexKey"
/// 需要展示的所有图片对应的key
public let StatusPictureViewURLsKey = "StatusPictureViewURLsKey"

extension StatusPictureView:UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.stotedPicUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:XMGPictureCellReuseIdentifier, for: indexPath) as! pictureViewCell
        
        cell.imageUrl = status?.stotedPicUrls?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(status?.LargePictureURLS?[indexPath.row])
        let info = [StatusPictureViewIndexKey:indexPath,StatusPictureViewURLsKey:status?.LargePictureURLS] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: StatusPictureViewSelected), object: self, userInfo: info)
        
        
    }
    
    
    
}


class pictureViewCell: UICollectionViewCell {
    var imageUrl:URL?{
        didSet{
            iconImageView.kf.setImage(with: imageUrl)
            if (imageUrl?.absoluteString as! NSString).pathExtension.lowercased() == "gif"
            {
                gifImageView.isHidden = false
            }else{
                 gifImageView.isHidden = true
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(){
        contentView.addSubview(iconImageView)
        iconImageView.addSubview(gifImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
        gifImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconImageView.snp.top)
            make.left.equalTo(self.iconImageView)
        }
        
    }
    private lazy var iconImageView:UIImageView = UIImageView()
    
    private lazy var gifImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "avatar_vgirl"))
        iv.isHidden = true
        return iv
    }()
}
