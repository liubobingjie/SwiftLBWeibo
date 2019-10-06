//
//  HttpsTool.swift
//  WeiboSwift
//
//  Created by mc on 2019/8/17.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Alamofire
enum MethodType
{
    case get
    case post
    
}
class HttpsTool: NSObject {
    
    //let parmeters = ["Accept":"application/json","Content-Type":"application/json"];
    
    class func requesData(URLString:String,type:MethodType,parmeters:[String:Any]? = nil,finshedCallback:@escaping (_ result:Any)->()){
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
       
        
        Alamofire.request(URLString, method: method, parameters:parmeters).responseJSON { (response) in
            //guard 校验result是否有值
            //print(response)
            guard let result = response.result.value else{
                print("校验result请求报错了")
                return
            }
            //如果有值直接将结果回调出去
            finshedCallback(result)

        }
        
        
    }
    
    class func uploadImage(URLString:String,image:UIImage,params:[String:String],success:@escaping(_ reault:[String:Any])->(),failure:@escaping (_ error: Error)->()){
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let data = image.jpegData(compressionQuality: 0.5)
            let fileName = String.init(describing: NSDate()) + ".png"
            multipartFormData.append(data!, withName: fileName, mimeType: "image/png")
            for (key,value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
        }, to: URLString) { (encodingResult) in
            switch encodingResult{
                
                case .success(let upload, _, _):
                
                
                upload.responseJSON { response in
                
                success(response.result.value as! [String: Any])// 已经转为字典
                
                }
                
                
                case .failure(let encodingError):
                
                failure(encodingError)
                
                }
                
                
            
            }
        }
    

}
