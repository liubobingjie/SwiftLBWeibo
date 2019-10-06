//
//  HomeRefreshView.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/25.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class HomeRefreshViewControl: UIRefreshControl {
    
    /// 定义变量记录是否需要旋转监听
    private var rotationArrowFlag = false
    /// 定义变量记录当前是否正在执行圈圈动画
    private var loadingViewAnimFlag = false
    override init() {
        super.init()
        setupUI()
    }
    
    private func  setupUI(){
        addSubview(refreshView)
        //refreshView.center = self.center
        
        refreshView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(60)

        }
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
     /// 定义变量记录是否需要旋转监听
   // private var rotationArrow = false
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y >= 0 {
            return
        }
        if isRefreshing && !loadingViewAnimFlag
        {
            print("圈圈动画")
            loadingViewAnimFlag = true
            // 显示圈圈, 并且让圈圈执行动画
            refreshView.startLoadingViewAnim()
            return
        }
        if frame.origin.y >= -50 && rotationArrowFlag
        {
            rotationArrowFlag = false
            refreshView.rotaionArrowIcon(flag: rotationArrowFlag)
            //rotationArrow = false
        }else if frame.origin.y < -50 && !rotationArrowFlag
        {
              rotationArrowFlag = true
            refreshView.rotaionArrowIcon(flag: rotationArrowFlag)
        }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoadingViewAnim()
        rotationArrowFlag = false
        
    }
    
    private lazy var refreshView :HomeRefreshView = HomeRefreshView.refreshView()
    

}
class HomeRefreshView: UIView {
    
    @IBOutlet weak var loadimageView: UIImageView!
    @IBOutlet weak var arrowIcon: UIImageView!
    @IBOutlet weak var tipView: UIView!
    /**
     旋转箭头
     */
    func rotaionArrowIcon(flag:Bool) {
        var angle = Double.pi
        if flag{
            angle = angle - 0.01
        }else{
            angle = angle + 0.01
        }
        UIView.animate(withDuration: 0.2) {
            let transFrom = CGAffineTransform.rotated(self.arrowIcon.transform)
            self.arrowIcon.transform = transFrom(CGFloat(angle))
            //self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
        
        
    }
    /**
     开始圈圈动画
     */
    func startLoadingViewAnim(){
        tipView.isHidden = true
        //创建动画
        let anim = CABasicAnimation(keyPath:"transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        anim.isRemovedOnCompletion = false
        loadimageView.layer.add(anim,forKey: nil)
    }
    /**
     停止圈圈动画
     */
    func stopLoadingViewAnim(){
        tipView.isHidden = false
        loadimageView.layer.removeAllAnimations()
    }
    
    
    
    
    class func refreshView()->HomeRefreshView {
        return Bundle.main.loadNibNamed("HomeRefreshView", owner: nil, options: nil)?.last as! HomeRefreshView
    }
    
}
