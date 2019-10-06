//
//  QRCodeViewController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController,UITabBarDelegate {
   //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    //容器的高度
    @IBOutlet weak var colletionHeight: NSLayoutConstraint!
    //冲击波的顶部约束
    @IBOutlet weak var scanLines: NSLayoutConstraint!
    @IBOutlet weak var customTabBar: UITabBar!
    @IBAction func ClickClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        customTabBar.selectedItem = customTabBar.items![0]
        self.customTabBar.delegate = self

      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        startAnmation()
        //开始扫描
        startScan()
        
       
    }
    private func startScan(){
        if !session.canAddInput(deviceInput!) {
            return
        }
        if !session.canAddOutput(output) {
            return
        }
        session.addInput(deviceInput!)
        session.addOutput(output)
        //设置解析数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        output.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue:dispatch_queue_main_t.main)
        view.layer.insertSublayer(previewLyer, at: 0)
        previewLyer.addSublayer(drawLayer)
        session.startRunning()
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
           //点击w二维码
            self.colletionHeight.constant = 300
            
        }else{
            //点击条形码
            self.colletionHeight.constant = 150
            
        }
        //停止动画
        self.scanLineView.layer.removeAllAnimations()
        //  重新开始动画
        
        startAnmation()
    }
    
    private func startAnmation(){
        self.scanLines.constant = -self.colletionHeight.constant
        self.scanLineView.layoutIfNeeded()
        UIView.animate(withDuration: 5.0) {
            self.scanLines.constant = self.colletionHeight.constant
            UIView.setAnimationRepeatCount(300)
            self.scanLineView.layoutIfNeeded()
        }
    }
    
    //MARK:-懒加载
    //回话
    private lazy var session : AVCaptureSession = AVCaptureSession()
    //拿到输入设备
    private lazy var deviceInput:AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        do{
             let input = try AVCaptureDeviceInput(device: device!)
             return input
        }catch{
            print(error)
            return nil
        }
    }()
    //拿到输出设备
    private lazy var output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
   //创建预览c图层
    private lazy var previewLyer: AVCaptureVideoPreviewLayer = {
        let pre = AVCaptureVideoPreviewLayer(session: session)
        pre.frame = UIScreen.main.bounds
        return pre
    }()
    // changjain 绘制边线的图层
    private lazy var drawLayer:CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.main.bounds
        return layer
    }()
   
}

extension QRCodeViewController:AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        clearConnerLayer()
        print(metadataObjects.last ?? "error")
        //获取扫描的位子信息
        for object in metadataObjects
        {
            if object is AVMetadataMachineReadableCodeObject
            {
                let codeoBject = previewLyer.transformedMetadataObject(for: object as! AVMetadataMachineReadableCodeObject)
                
                drawConners(codeObject: codeoBject as! AVMetadataMachineReadableCodeObject)
            }
            
        }
        
    }
    //绘制图形边框
    func drawConners(codeObject:AVMetadataMachineReadableCodeObject){
        if codeObject.corners.isEmpty {
            return
        }
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.red.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        //layer.path = UIBezierPath(rect:CGRect(x: 100, y: 100, width: 200, height: 200)).cgPath
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        
        // 取出第0个点
        //CGPointMakeWithDictionaryRepresentation((codeObject.corners[index] as! CFDictionary), &point)
        
        point = CGPoint.init(dictionaryRepresentation: (codeObject.corners[index] as! CFDictionary)) ?? CGPoint.zero
        path.move(to: point)
        while index < codeObject.corners.count {
            
            point = CGPoint.init(dictionaryRepresentation: (codeObject.corners[index+1] as! CFDictionary)) ?? CGPoint.zero
            
            path.addLine(to: point)
       
        }
        path.close()
        drawLayer.addSublayer(layer)
    }
    
    private func clearConnerLayer(){
        if drawLayer.superlayer == nil || drawLayer.superlayer?.accessibilityElementCount() == 0 {
            return
        }
        for subLayer in drawLayer.sublayers!
        {
           subLayer.removeFromSuperlayer()
        }
    }
    
    
    
}
