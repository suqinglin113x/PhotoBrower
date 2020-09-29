//
//  TCHotelPhotoBrowerCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
import SDWebImage

private let screenW: CGFloat = UIScreen.main.bounds.size.width
private let screenH: CGFloat = UIScreen.main.bounds.size.height
private let isIphoneX = (screenH >= 812) ? true : false

class TCHotelPhotoBrowerCell: UICollectionViewCell {
    
    var imageV: UIImageView!
    var scrollView: UIScrollView!
    var tipView: UIView!
    var tipLabel: UILabel!
    var photoNumL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()


    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollView = UIScrollView(frame: self.contentView.frame)
        scrollView.contentSize = CGSize(width: screenW, height: screenH)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.contentView.addSubview(scrollView)
        imageV = UIImageView(frame: self.contentView.frame)
        scrollView.addSubview(imageV)
        tipView = UIView(frame: CGRect(x: 10, y: screenH-30-34, width: screenW-20, height: 30))
        tipView.layer.cornerRadius = 15
        tipView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        self.contentView.addSubview(tipView)
        tipLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 250, height: 30))
        tipLabel.text = "豪华江景套房豪华江景套房豪华江景套房豪华江景套房豪华江景套房豪华江景套房"
        tipLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
        tipLabel.textColor = .white
        tipView.addSubview(tipLabel)
        photoNumL = UILabel(frame: CGRect(x: tipView.bounds.size.width-10-50, y: 0, width: 50, height: 30))
        photoNumL.text = "32/453"
        photoNumL.textColor = .white
        photoNumL.textAlignment = .right
        photoNumL.font = UIFont(name: "PingFangSC-Semibold", size: 13)
        tipView.addSubview(photoNumL)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configModel(url: String) {
        
        imageV.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .refreshCached) { (image, error, cacheType, url) in
            if image != nil {
                let imageSize = image!.size
                let scale = CGFloat(imageSize.height) / CGFloat(imageSize.width)
                let realH = screenW*scale
                DispatchQueue.main.async {
        
                    let frame = CGRect(x: 0, y: 0, width: (screenW), height: (realH))
                    self.imageV.frame = frame
                    
                    if realH <= screenH {
                        self.imageV.center = self.contentView.center
                        self.scrollView.contentSize = CGSize(width: screenW, height: screenH)
                    } else {
                        self.scrollView.contentSize = CGSize(width: screenW, height: realH)
                    }
                    
                }
            }
            
            
        }
        
    }
    
    
    func configPhotoBadge(current: Int, allNum: Int) {
        photoNumL.text = "\(current)/\(allNum)"
    }
    
    
    
}

extension TCHotelPhotoBrowerCell: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let contenSize = scrollView.contentSize
        
        if contenSize.height <= screenH {
            imageV.center = CGPoint(x: contenSize.width*0.5, y: self.contentView.center.y)
        } else {
            imageV.center = CGPoint(x: contenSize.width*0.5, y: contenSize.height*0.5)
        }
        
    }
    
}
