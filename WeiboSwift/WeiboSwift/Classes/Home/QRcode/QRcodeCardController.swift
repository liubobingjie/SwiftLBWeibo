//
//  QRcodeCardController.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SnapKit

class QRcodeCardController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的名片"
        view.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
        let bgImage = generate(from: "风云悟道")
        let iconImage  = UIImage(named: "ic.png")
        
        let newimage = creatIamge(bg1Image: bgImage!, iconImage: iconImage!)
       
        iconView.image = newimage

       
    }
    func creatIamge(bg1Image:UIImage,iconImage:UIImage) -> UIImage {
        UIGraphicsBeginImageContext(bg1Image.size)
        bg1Image.draw(in: CGRect(origin: CGPoint.zero, size: bg1Image.size))
        
        let width:CGFloat = 50.0
        let height = width
        let x = (bg1Image.size.width - width) * 0.5
        let y = (bg1Image.size.height - height) * 0.5
        iconImage.draw(in: CGRect(x: x, y: y, width: width, height: height))
        
        let newimage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newimage
        
    }
    
    func generate(from string: String) -> UIImage? {
              let context = CIContext()
              //let data = string.data(using: String.Encoding.ascii)
                 let data = string.data(using: String.Encoding.utf8)
        
                if let filter = CIFilter(name: "CIQRCodeGenerator") {
                        filter.setValue(data, forKey: "inputMessage")
                         let transform = CGAffineTransform(scaleX: 7, y: 7)
                         if let output = filter.outputImage?.transformed(by: transform), let cgImage = context.createCGImage(output, from: output.extent) {
                                 return UIImage(cgImage: cgImage)
                            }
                     }
                 return nil
             }
//    private func creatQRcodeimage()->UIImage{
//        let filter = CIFilter(name: "CIQRCodeGenerator")
//        filter?.setDefaults()
//        filter?.setValue("风云悟道".data(using: String.Encoding.utf8), forKey: "inputMessage")
//        let climage = filter?.outputImage
//        let transform = CGAffineTransform(scaleX: 7, y: 7)
//
//       let output = climage!.transformed(by: transform),
//
//        let cgImage = context.createCGImage(output, from: output.extent) {
//                            return UIImage(cgImage: cgImage)
//                      }
//
//        return UIImage(ciImage: climage!)
//
//    }
    /**
     根据CIImage生成指定大小的高清UIImage
     
     :param: image 指定CIImage
     :param: size    指定大小
     :returns: 生成好的图片
     */
  
    private lazy var iconView:UIImageView = UIImageView()

  

}
