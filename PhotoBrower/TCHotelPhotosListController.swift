//
//  TCHotelPhotosListController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//


import UIKit
import SDWebImage

private let margin: CGFloat = 10
private let isIphoneX = ((UIScreen.main.bounds.size.height >= 812) ? true : false)

class TCHotelPhotosListController: UIViewController {
    var photosList: [String]? = []
    
    lazy var collectionView: UICollectionView! = {
        let flow = UICollectionViewFlowLayout()
        let coll = UICollectionView.init(frame: .zero, collectionViewLayout: flow)
        coll.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height - (isIphoneX ? 88 : 64) - 40)
        coll.delegate = self
        coll.dataSource = self
        coll.contentInsetAdjustmentBehavior = .never
        coll.register(UINib.init(nibName: "TCHotelPhotoListCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TCHotelPhotoListCell")
        coll.backgroundColor = .white
        return coll
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.view.addSubview(collectionView)
        self.getPhotosListData()
        
    }

}

extension TCHotelPhotosListController {
    func getPhotosListData() {
        
        let tem = ["https://inews.gtimg.com/newsapp_bt/0/12483150010/1000",
                   "https://ww2.sinaimg.cn/bmiddle/0079uoqmly1gittwl5ugwj30gi192gqa.jpg",
                   "https://image.fosunholiday.com/cl/image/20200918/5f6453c9e822f1174ae418f9_658-5804_pic.jpeg",
                   "https://inews.gtimg.com/newsapp_bt/0/12483150012/1000",
                   "https://inews.gtimg.com/newsapp_bt/0/12483150013/1000",
                   "https://ww4.sinaimg.cn/bmiddle/0079uoqmly1gittwktg9fj30oo1h0qae.jpg"
        ]
        photosList?.append(contentsOf: tem)
        photosList?.append(contentsOf: tem)
        self.collectionView.reloadData()
    }
}

extension TCHotelPhotosListController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TCHotelPhotoListCell", for: indexPath) as! TCHotelPhotoListCell
        cell.configModel(url: photosList![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let phBroweVC = TCHotelPhotosBrowerController()
        phBroweVC.currentIndex = indexPath.row
        phBroweVC.photosList = photosList
        phBroweVC.modalPresentationStyle = .overFullScreen
        self.present(phBroweVC, animated: true, completion: nil)

    }
    
    
}

extension TCHotelPhotosListController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.bounds.size.width - 3*margin)/2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
}
