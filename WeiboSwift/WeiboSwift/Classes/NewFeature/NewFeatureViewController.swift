//
//  NewFeatureViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/20.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

let XMGRootViewControllerSwitchNotification = "XMGRootViewControllerSwitchNotification"

class NewFeatureViewController: UICollectionViewController {
    static let identifier = "identifier"
    private let pageCount = 4
    private var layout:UICollectionViewFlowLayout = NewFreatureLayout()

    init() {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
      super.viewDidLoad()
        collectionView.register(NewFeatureCell.self, forCellWithReuseIdentifier: NewFeatureViewController.identifier)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        //设置layout 布局
//        layout.itemSize = UIScreen.main.bounds.size
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.scrollDirection = .horizontal
//
//        collectionView.isPagingEnabled = true
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.bounces = false
//
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewFeatureViewController.identifier, for: indexPath as IndexPath) as! NewFeatureCell
        //cell.backgroundColor = UIColor.red
        
        cell.imageIdex = indexPath.item
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        let path = collectionView.indexPathsForVisibleItems.last!
        
      let cell = collectionView.cellForItem(at: path) as! NewFeatureCell
        cell.startAnmial()
    }
    
    
        
    }

 class NewFeatureCell:UICollectionViewCell
{
    
    var imageIdex:Int?{
        didSet{
            iconView.image = UIImage(named: "new_feature_\(imageIdex! + 1)")
            if imageIdex == 3{
               startBtn.isHidden = false
                
            }else{
                 startBtn.isHidden = true
            }
        }
    }
    
    fileprivate func startAnmial(){
        startBtn.transform = CGAffineTransform(scaleX: 0.001, y: 0.0)
        startBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: UIView.AnimationOptions(rawValue: 0), animations: {
            self.startBtn.transform = CGAffineTransform.identity
        }) { (_) in
            self.startBtn.isUserInteractionEnabled = true
        }
    }
    
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI(){
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalToSuperview()
        }
        contentView.addSubview(startBtn)
        startBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
        }
    }
    
    private lazy var iconView = UIImageView()
    
    private lazy var startBtn = { () -> UIButton in
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "new_feature_button"), for: UIControl.State.normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), for: UIControl.State.highlighted)
        btn.addTarget(self, action: #selector(NewFeatureCell.comClick), for: UIControl.Event.touchUpInside)
        
        return btn
    }()
    
   @objc public func comClick(){
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: XMGRootViewControllerSwitchNotification), object: true, userInfo: nil)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NewFreatureLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        //设置layout 布局
       itemSize = UIScreen.main.bounds.size
       minimumLineSpacing = 0
        minimumInteritemSpacing = 0
      scrollDirection = .horizontal
        
        collectionView!.isPagingEnabled = true
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.bounces = false
        
        
    }
}
   
    
    
    
   

