//
//  TestViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/3/30.
//  Copyright © 2021 苏庆林. All rights reserved.
//

import UIKit
private let margin: CGFloat = 10
private let isIphoneX = ((UIScreen.main.bounds.size.height >= 812) ? true : false)

class TestViewController: UIViewController {
    lazy var collectionView: UICollectionView! = {
        let flow = UICollectionViewFlowLayout()
        let coll = UICollectionView.init(frame: .zero, collectionViewLayout: flow)
        coll.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        coll.delegate = self
        coll.dataSource = self
        coll.register(UINib.init(nibName: "TCHotelPhotoListCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TCHotelPhotoListCell")
        coll.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        coll.backgroundColor = .yellow
        coll.contentInsetAdjustmentBehavior = .never
        return coll
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        self.view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

}
extension TestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TCHotelPhotoListCell", for: indexPath) as! TCHotelPhotoListCell
        cell.configModel(url: "http:ss")
        return cell
    }
    
    
}

extension TestViewController: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 400, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header", for: indexPath)
        
        header.backgroundColor = .orange
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
    }
    
    
}
