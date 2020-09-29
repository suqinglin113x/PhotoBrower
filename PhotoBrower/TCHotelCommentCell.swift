//
//  TCHotelCommentCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/21.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelCommentCell: UITableViewCell {
    
    @IBOutlet weak var userNameL: UILabel!
    @IBOutlet weak var hotelLogo: UIImageView!
    @IBOutlet weak var gradeL: UILabel!
    @IBOutlet weak var levelL: UILabel!
    @IBOutlet weak var contentL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func configModel(model: String) {
        contentL.text = model
        
        
        
    }
    
    static func getCellHeight(model: String) -> (CGFloat) {
        let content = model as NSString
        let contentH = content.boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 15*2, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.init(name: "PingFangSC-Regular", size: 13)!], context: nil).size.height + 10
        
        return contentH 
    }
}
