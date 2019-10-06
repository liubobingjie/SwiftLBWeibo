//
//  EmoticPackage.swift
//  EmoticonDemo
//
//  Created by mc on 2019/9/1.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class EmoticPackage: NSObject {
    //当前组
    var id:String?
      //当前组名字
    var group_name_cn:String?
       //当前组所有表qing对象
    var emoticous:[Emoticon]?
    
    //单例优化性能
    static let packageList:[EmoticPackage] = EmoticPackage.loadPackAges()
    
    class func emotconString(str:String)-> NSAttributedString?{
        
        let strM = NSMutableAttributedString(string: str)
        
        do{
            // 1.创建规则
            let pattern = "\\[.*?\\]"
             // 2.创建正则表达式对象
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            // 3.开始匹配
            let res = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
            // 4取出结果
            var count = res.count
            while count>0 {
                 count = count - 1
                let checkIngRes = res[count]
               
                let tempStr = (str as NSString).substring(with: checkIngRes.range)
                if let emoticon = emoticonWithStr(str: tempStr){
                   // print(emoticon.chs)
                    let attrStr = EmoticonTextAttachment.imageText(emoticon: emoticon, font: 20)
                    strM.replaceCharacters(in: checkIngRes.range, with: attrStr)
                }
                
            }
            return strM
        }catch{
            print(error)
            return nil
        }
        
    }
    
    /**
     根据表情文字找到对应的表情模型
     
     :param: str 表情文字
     
     :returns: 表情模型
     */
    class func emoticonWithStr(str: String) -> Emoticon?{
        var emotico :Emoticon?
        for package in EmoticPackage.packageList{
            emotico = package.emoticous?.filter({ (e) -> Bool in
                return e.chs == str
            }).last
            if emotico != nil{
                break
            }
        }
        return emotico
        
        
    }
    private class func loadPackAges()->[EmoticPackage]{
          var packages = [EmoticPackage]()
        // 创建最近组
        let pk = EmoticPackage(id: "")
        pk.group_name_cn = "最近"
        pk.emoticous = [Emoticon]()
        pk.appendEmtyEmoticons()
        packages.append(pk)
    
        
        //加载emoticons.plist
        let path = Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")
        let dict = NSDictionary(contentsOfFile: path!)!
        let dicArray = dict["packages"] as! [[String:Any]]
        //print(dicArray)
      
        for d in dicArray{
            let package = EmoticPackage.init(id: d["id"]as! String)
            packages.append(package)
            
            package.loadEnoticons()
            package.appendEmtyEmoticons()
        }
        return packages
        
    }
    
   
    func loadEnoticons (){
        let enoticoDict = NSDictionary(contentsOfFile: infoPath(fileName: "info.plist"))!
        //print(enoticoDict)
        group_name_cn = enoticoDict["group_name_cn"] as! String
        let dicArray = enoticoDict["emoticons"] as! [[String:Any]]
        emoticous = [Emoticon]()
        var index = 0
        for dic in dicArray{
          if index == 20
          {
            //print("添加删除")
            emoticous?.append(Emoticon(isRemoveButton: true))
            index = 0
            
            }
            emoticous?.append( Emoticon(dict: dic as! [String : String], id: id))
            index = index + 1
        }
        
    }
    
    func appendEmtyEmoticons(){
        let count = emoticous!.count % 21
        
        for _ in count..<20
        {
            emoticous?.append(Emoticon(isRemoveButton: false))
        }
         emoticous?.append(Emoticon(isRemoveButton: true))
        
        
    }
    func appendEmoticons(emoticon:Emoticon){
        if emoticon.isRemoveButton {
            return
        }
        let catains = emoticous!.contains(emoticon)
        if !catains{
             // 删除删除按钮
            emoticous?.removeLast()
            emoticous?.append(emoticon)
        }
        // 3.对数组进行排序
        
        var result = emoticous?.sorted(by: { (e1:Emoticon, e2:Emoticon) -> Bool in
            return e1.times > e2.times
        })
         // 4.删除多余的表情
        if !catains{
            result?.removeLast()
            //添加删除按钮
            result?.append(Emoticon(isRemoveButton: true))
        }
        emoticous = result
        
        
    }
    
    class func bundlePath()->String {
        
        return  Bundle.main.bundlePath + "/Emoticons.bundle"
        
       // return Bundle.main.path(forResource: "emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
    }
    func infoPath(fileName:String)->String{
        return EmoticPackage.bundlePath() + "/" + id! + "/" + fileName
    }
     init(id:String) {
        self.id = id
    }
    

}
class Emoticon: NSObject {
    //表情对应的文字
   @objc var chs:String?
    //表情对应的图片
   @objc var png:String?
   {
    didSet{
        imagePath = EmoticPackage.bundlePath() + "/" + id! + "/" + png!
    }
    }
      //表情对应的十六进制字符串
   @objc var code:String?
    {
       didSet{
        let scanner = Scanner(string: code!)
        var result:UInt32 = 0
        scanner.scanHexInt32(&result)
        emojiStr = "\(Character(UnicodeScalar(result)!))"
        
        }
    
    }
   @objc var id:String?
    @objc var imagePath:String?
    
     var emojiStr: String?
    
    var isRemoveButton:Bool = false
    
    var times:Int = 0
    
    init(isRemoveButton: Bool)
    {
        super.init()
        self.isRemoveButton = isRemoveButton
    }
    
    init(dict:[String:String],id:String?){
        super.init()
        self.id = id
        setValuesForKeys(dict)    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
