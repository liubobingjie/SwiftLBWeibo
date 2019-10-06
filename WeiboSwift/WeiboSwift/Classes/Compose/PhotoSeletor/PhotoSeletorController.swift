//
//  PhotoSeletorController.swift
//  PictureSelectorDemo
//
//  Created by mc on 2019/9/7.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

private let Identifier = "Identifier"

class PhotoSeletorController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI(){
        view.addSubview(collcetionView)
        //填充全屏
        collcetionView.translatesAutoresizingMaskIntoConstraints = false
        var cons = [NSLayoutConstraint]()
        cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[collcetionView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView":collcetionView])
         cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collcetionView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["collcetionView":collcetionView])
        
        view.addConstraints(cons)
        
    }
    
    //MARK:懒加载
    private lazy var collcetionView:UICollectionView = {
       let vc =  UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoSeletorViewLayout())
        vc.backgroundColor = UIColor.gray
        vc.dataSource = self
        vc.register(PhotoSeletorCell.self, forCellWithReuseIdentifier: Identifier)
        return vc;
    }()
   public lazy var pictureImages = [UIImage]()

}
extension PhotoSeletorController:UICollectionViewDataSource,PhotoSeletorCellDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pictureImages.count + 1
        //return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collcetionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! PhotoSeletorCell
        cell.backgroundColor = UIColor.white
        cell.photoCellDelegate = self
        if pictureImages.count == indexPath.item {
             cell.image = nil
        }else{
            cell.image = pictureImages[indexPath.item]
        }
       
        return cell
    }
    
    func photoDidAddSelector(cell: PhotoSeletorCell) {
       // print("photoDidAddSelector")
        /**
         case photoLibrary（图片库
         case camera (相机)
         case savedPhotosAlbum （相册）自己拍的可随意删除
         */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            print("不能打开相册")
            return
        }
        //创建图片选择器
        let picVC = UIImagePickerController()
        picVC.delegate = self
        picVC.allowsEditing = true
        present(picVC,animated: true,completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        let strkey = UIImagePickerController.InfoKey.originalImage
        
        let newImage = (info[strkey] as! UIImage).imageWithScale(width: 200)!
        pictureImages.append(newImage)
        collcetionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    func photoDidRemoveSelector(cell: PhotoSeletorCell) {
         // print("photoDidRemoveSelector")
      let indexPath = collcetionView.indexPath(for: cell)
        pictureImages.remove(at: indexPath!.item)
        collcetionView.reloadData()
        
    }
    
    
    
    
}


@objc protocol PhotoSeletorCellDelegate:NSObjectProtocol{
    @objc optional func photoDidAddSelector(cell:PhotoSeletorCell)
    @objc optional func photoDidRemoveSelector(cell:PhotoSeletorCell)
}
class PhotoSeletorCell: UICollectionViewCell {
    var image:UIImage? {
        didSet{
            if image != nil{
                addBtn.setImage(image, for: UIControl.State.normal)
               addBtn.isUserInteractionEnabled = false
                removeBtn.isHidden = false
            }else{
                addBtn.isUserInteractionEnabled = true
                addBtn.setImage(UIImage(named: "compose_pic_add"), for: UIControl.State.normal)
                removeBtn.isHidden = true

            }
            
        }
    }
    weak var photoCellDelegate:PhotoSeletorCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView(){
        contentView.addSubview(addBtn)
        contentView.addSubview(removeBtn)
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
       
       
        
        var cons = [NSLayoutConstraint]()
        cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[addBtn]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["addBtn":addBtn])
         cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[addBtn]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["addBtn":addBtn])
        
        cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "H:[removeBtn]-2-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["removeBtn":removeBtn])
         cons = cons + NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[removeBtn]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["removeBtn":removeBtn])
        
        contentView.addConstraints(cons)
        
        
    }
    //懒加载
    private lazy var removeBtn: UIButton = {
       let btn = UIButton()
        btn.isHidden = true
       btn.setImage(UIImage(named: "compose_photo_close"), for: UIControl.State.normal)
    btn.addTarget(self, action: #selector(removeClick), for: UIControl.Event.touchUpInside)
        return btn;
    }()
    private lazy var addBtn: UIButton = {
        let add = UIButton()
        add.imageView?.contentMode = .scaleAspectFill
        add.setImage(UIImage(named: "compose_pic_add"), for: UIControl.State.normal)
        add.setImage(UIImage(named: "compose_pic_add_highlighted"), for: UIControl.State.highlighted)
        add.addTarget(self, action: #selector(addBtnClick), for: UIControl.Event.touchUpInside)
        return add
    }()
    
    //MARK:监听按钮点击
    @objc func removeClick(){
        photoCellDelegate?.photoDidRemoveSelector!(cell: self)
        
    }
    @objc func addBtnClick(addbtn:UIButton){
       
             photoCellDelegate?.photoDidAddSelector!(cell: self)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhotoSeletorViewLayout:UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        itemSize = CGSize(width: 90, height: 90)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
