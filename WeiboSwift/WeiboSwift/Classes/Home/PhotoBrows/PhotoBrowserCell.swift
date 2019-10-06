//
//  PhotoBrowserCell.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/31.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Kingfisher

protocol PhotoBrowserCellDelegate:NSObjectProtocol {
    func photoBrowserCellDidClose(cell:PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell {
    
    weak var photoBrowserCellDelegate:PhotoBrowserCellDelegate?
   
    
    var imageURL: URL? {
        didSet{
            reset()
            activity.startAnimating()
            iconView.kf.setImage(with: imageURL, placeholder: nil, options: nil, progressBlock: nil) { (image:Image?, _, _, _) in
                self.activity.stopAnimating()
                self.setImageViewPostion()
            }
            
        }
    }
    
    /**
     重置scrollview和imageview的属性
     */
    func reset(){
        scrollview.contentInset = UIEdgeInsets.zero
        scrollview.contentOffset = CGPoint.zero
        scrollview.contentSize = CGSize.zero
        iconView.transform = .identity
    }
    /**
     调整图片显示的位置
     */
    private func setImageViewPostion(){
        let size = self.displaySize(image: iconView.image!)
        
        if size.height < UIScreen.main.bounds.size.height
        {//小图 居中显示
            iconView.frame = CGRect(origin: CGPoint.zero, size: size)
            let y = (UIScreen.main.bounds.size.height - iconView.frame.size.height) * 0.5
            self.scrollview.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        }else{
            //大图
            iconView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollview.contentSize = size
        }
    
    }
    // 按照图片的宽高比计算图片显示的大小
    private func displaySize(image:UIImage) -> CGSize {
        let scale = image.size.height / image.size.width
        
        let width = UIScreen.main.bounds.size.width
        let height = width * scale
        
        return CGSize(width: width, height: height)
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setuoUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func  setuoUI() {
        contentView.addSubview(scrollview)
        scrollview.addSubview(iconView)
        contentView.addSubview(activity)
        
        scrollview.frame = UIScreen.main.bounds
        scrollview.delegate = self
        scrollview.maximumZoomScale = 2.0
        scrollview.minimumZoomScale = 0.5
        activity.center = contentView.center
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(close))
        iconView.addGestureRecognizer(tap)
        iconView.isUserInteractionEnabled = true
        
    }
    @objc func close(){
        photoBrowserCellDelegate?.photoBrowserCellDidClose(cell: self)
        
    }
    
    //懒加载
    lazy var scrollview:UIScrollView = UIScrollView()
    lazy var iconView:UIImageView = {
        let iconv = UIImageView()
        iconv.contentMode = .scaleAspectFill
        return iconv
    }()
    
    private lazy var activity:UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
}

extension PhotoBrowserCell:UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return iconView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        
        var offsetX = (UIScreen.main.bounds.width - view!.frame.width) * 0.5
          var offsetY = (UIScreen.main.bounds.height - view!.frame.height) * 0.5
        offsetX = offsetX < 0 ? 0 : offsetX
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        
        
    }
    
}
