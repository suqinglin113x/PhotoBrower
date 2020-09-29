//
//  TCHotelOrderHotelInfowCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/22.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelOrderHotelInfowCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.backgroundColor = .white
        
    }
    override func layoutSubviews() {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
