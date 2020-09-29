//
//  TCHotelOrderTripInfoCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/28.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelOrderTripInfoCell: UITableViewCell {

    @IBOutlet weak var roomIDL: UILabel!
    @IBOutlet weak var lastNameL: UILabel!
    @IBOutlet weak var firstNameL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configData(roomID: String) {
        roomIDL.text = "房间\(roomID)"
        
    }
    
}
