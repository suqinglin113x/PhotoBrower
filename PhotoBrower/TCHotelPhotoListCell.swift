//
//  TCHotelPhotoListCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
import SDWebImage

class TCHotelPhotoListCell: UICollectionViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func configModel(url: String) {
        
        imageV.sd_setImage(with: URL(string: url))
        
    }
    
}
