//
//  StatusTableViewCell.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/24.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit


enum StatusTableViewCellIdentfiler :String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    
    static func cellID(status:Status)->String{
        
        if status.retweeted_status != nil {
            
            return StatusTableViewCellIdentfiler.ForwardCell.rawValue
        }else{
            return StatusTableViewCellIdentfiler.NormalCell.rawValue
        }
        
    }
}

let XMGPictureCellReuseIdentifier = "XMGPictureCellReuseIdentifier"
class StatusTableViewCell: UITableViewCell {
    /// 保存配图的宽度约束
    var pictureWidthCons: Constraint?
    /// 保存配图的高度约束
    var pictureHeightCons: Constraint?
    /// 保存配图的底部约束
    var pictureBottonCons: Constraint?
    var status:Status?{
        
        didSet{
            let vc:CellHeadView = headView as! CellHeadView
            vc.Headstatus = status
            
           //contentLabel.text = status?.text
            contentLabel.attributedText = EmoticPackage.emotconString(str: status?.text ?? " ")
            //设置配图尺寸
            //pictureView.status = status
            
            let picTstatus = status?.retweeted_status != nil ? status?.retweeted_status : status
            
            let size = pictureView.calculateImageSize(status: picTstatus!)
            pictureWidthCons?.update(offset: size.width)
            pictureHeightCons?.update(offset: size.height)
            
            if size.height == 0  {
                pictureBottonCons?.update(offset: 0)
            }else{
                  pictureBottonCons?.update(offset: 10)
            }
            
        
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //初始化ui
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setUpUI(){
        
       contentView.addSubview(headView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(footView)
        headView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.size.width)
            make.height.equalTo(60)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.left.equalTo(headView).offset(10)
            make.width.equalToSuperview().offset(-20)
        }
        
       
//
        footView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(self.pictureView.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.width.equalTo(UIScreen.main.bounds.size.width)
        }
    }
    
    
  public func rowHeight(stutas:Status) -> CGFloat {
        self.status = stutas
        layoutIfNeeded()
        return footView.frame.maxY

    }
    
//    ///MARK:--懒加载
    //头视图
    private lazy var headView:UIView = {
        let head = CellHeadView()
        return head
    }()

//    //正文
    public lazy var contentLabel:UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.darkGray
        lab.font = UIFont.systemFont(ofSize: 14)
        lab.numberOfLines = 0
        return lab
    }()
   
    /// 配图
    public lazy var pictureView: StatusPictureView = StatusPictureView()
    //底部工具条
    public lazy var footView:UIView = {
        let foot = CellFootView()
        return foot
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

}



