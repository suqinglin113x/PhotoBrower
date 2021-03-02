//
//  TCSubmitDiscountCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/24.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCSubmitDiscountCell: UITableViewCell {
    @IBOutlet weak var discountVConstraintH: NSLayoutConstraint!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var couponView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        let tapCoupon = UITapGestureRecognizer(target: self, action: #selector(tapCouponViewAction))
        
    }

    func configData(orderType: OrderSourceType) {
        if orderType != .travel {
            self.discountView.isHidden = true
            self.discountVConstraintH.constant = 0
            self.discountView.subviews.forEach({$0.removeFromSuperview()})
        }
    }
    
    @objc func tapCouponViewAction() {
        debugPrint("选择优惠券")
        
    }
    @IBAction func switchClickAction(_ sender: UISwitch) {
        debugPrint(sender.isOn)
    }
}
