//
//  TCHotelCommentHeaderView.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/21.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelCommentHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var wholeGrandeL: UILabel!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var wholeLevelL: UILabel!
    
    @IBOutlet weak var cleanProgress: UIView!
    @IBOutlet weak var cleanGradeL: UILabel!
    @IBOutlet weak var serviceProgress: UIView!
    @IBOutlet weak var serviceGradeL: UILabel!
    @IBOutlet weak var comfortProgress: UIView!
    @IBOutlet weak var comfortGradeL: UILabel!
    @IBOutlet weak var locationProgress: UIView!
    @IBOutlet weak var locationGradeL: UILabel!
    
    
    func configWithData() {
        
        //
        let str = "3.3/5分" as NSString
        let attri = NSMutableAttributedString(string: str as String)
        let location: Int = str.range(of: "/").location
        attri.addAttributes([NSAttributedString.Key.font:UIFont(name: "PingFangSC-regular", size: 14) as Any], range: NSRange(location: location, length: 3))
        attri.addAttributes([NSAttributedString.Key.foregroundColor:UIColor(red: 0.4, green: 0.4, blue: 0.4,alpha:1)], range: NSRange(location: location, length: 3))
        
        wholeGrandeL.attributedText = attri
        
        // star
        let grade: CGFloat = 3.3
        let margin: CGFloat = 2
        let eachStarW: CGFloat = 13
        for i in stride(from: 1, to: 6, by: 1) {
            let starIV = UIImageView()
            starIV.frame = CGRect(x: 6 + (eachStarW+margin) * CGFloat(i-1), y: 0, width: eachStarW, height: eachStarW)
            starView.addSubview(starIV)
            if CGFloat(i) <= grade {
                starIV.image =  UIImage.init(named: "hotel_full_star")
            } else {
                if (CGFloat(i) - grade) < 1 {
                    starIV.image =  UIImage.init(named: "hotel_half_star")
                } else {
                    starIV.image =  UIImage.init(named: "hotel_grey_star")
                }
                
            }
        }
        //
        let cleanProgress1 = UIView()
        cleanProgress1.backgroundColor = UIColor(red: 0.27, green: 0.57, blue: 1, alpha: 1)
        cleanProgress1.frame = CGRect(x: 0, y: 0, width: cleanProgress.bounds.size.width * 0.7, height: cleanProgress.bounds.size.height)
        cleanProgress1.layer.cornerRadius = 2.5
        cleanProgress.addSubview(cleanProgress1)
        
        let serviceProgress1 = UIView()
        serviceProgress1.backgroundColor = UIColor(red: 0.27, green: 0.57, blue: 1, alpha: 1)
        serviceProgress1.frame = CGRect(x: 0, y: 0, width: serviceProgress.bounds.size.width * 0.8, height: serviceProgress.bounds.size.height)
        serviceProgress1.layer.cornerRadius = 2.5
        serviceProgress.addSubview(serviceProgress1)
        
        let comfortProgress1 = UIView()
        comfortProgress1.backgroundColor = UIColor(red: 0.27, green: 0.57, blue: 1, alpha: 1)
        comfortProgress1.frame = CGRect(x: 0, y: 0, width: comfortProgress.bounds.size.width * 0.5, height: comfortProgress.bounds.size.height)
        comfortProgress1.layer.cornerRadius = 2.5
        comfortProgress.addSubview(comfortProgress1)
        
        let locationProgress1 = UIView()
        locationProgress1.backgroundColor = UIColor(red: 0.27, green: 0.57, blue: 1, alpha: 1)
        locationProgress1.frame = CGRect(x: 0, y: 0, width: locationProgress.bounds.size.width * 1, height: locationProgress.bounds.size.height)
        locationProgress1.layer.cornerRadius = 2.5
        locationProgress.addSubview(locationProgress1)
        
        
    }
    
    
    
}
