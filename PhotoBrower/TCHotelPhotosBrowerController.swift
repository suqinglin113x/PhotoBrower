//
//  TCHotelPhotosBrowerController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelPhotosBrowerController: UIViewController {
    var photosList: [String]? = []
    /// 当前页码
    var currentIndex: Int?
    
    var statusH: CGFloat = {
        var statusH: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusH = (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
        } else {
            statusH = UIApplication.shared.statusBarFrame.height
        }
        return statusH
    }()
    lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: statusH, width: 44, height: 44)
        backButton.setImage(UIImage.init(named: "back_white"), for: .normal)
        backButton.addTarget(self,action:#selector(closeVC),for:.touchUpInside)
        return backButton
    }()
    
    lazy var collectionView: UICollectionView! = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let coll = UICollectionView.init(frame: .zero, collectionViewLayout: flow)
        coll.isPagingEnabled = true
        coll.frame = self.view.bounds
        coll.delegate = self
        coll.dataSource = self
        
        coll.register(TCHotelPhotoBrowerCell.self, forCellWithReuseIdentifier: "TCHotelPhotoBrowerCell")
        return coll
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.view.addSubview(backButton)
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(item: currentIndex!, section: 0), at: .centeredHorizontally, animated: true)

    }
    
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension TCHotelPhotosBrowerController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TCHotelPhotoBrowerCell", for: indexPath) as! TCHotelPhotoBrowerCell
        
        cell.configModel(url: photosList![indexPath.row])
        cell.configPhotoBadge(current: (currentIndex ?? 0) + 1, allNum: (photosList?.count ?? 0))
        
        
        return cell
    }
    
}

extension TCHotelPhotosBrowerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return UIScreen.main.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension TCHotelPhotosBrowerController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let w = UIScreen.main.bounds.size.width
        let offsetX = scrollView.contentOffset.x
        
        currentIndex = Int(offsetX / w)
        let cell = collectionView.cellForItem(at: IndexPath(row: currentIndex!, section: 0)) as! TCHotelPhotoBrowerCell
        cell.configPhotoBadge(current: currentIndex! + 1, allNum: photosList?.count ?? 0)
    }
}
