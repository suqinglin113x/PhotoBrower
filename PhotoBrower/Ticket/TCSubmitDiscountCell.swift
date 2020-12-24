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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    func configData(orderType: OrderSourceType) {
        if orderType == .presale {
            self.discountView.isHidden = true
            self.discountVConstraintH.constant = 0
        }
    }
    
}
