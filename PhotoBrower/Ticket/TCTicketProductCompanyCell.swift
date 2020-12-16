//
//  TCTicketProductCompanyCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/16.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCTicketProductCompanyCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var baseInfo: TCBaseInfo? {
        didSet {
            self.configData()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    private func configData() {
        icon.sd_setImage(with: URL(string: baseInfo?.company?.urlLogo ?? ""), completed: nil)
        titleLabel.text = baseInfo?.company?.companyName
        
    }
    
    
    
    @IBAction func contactSeller(_ sender: Any) {
        debugPrint("联系卖家")
        let tel = "tel://\(baseInfo?.company?.tel ?? "")"
        UIApplication.shared.open(URL(string: tel)!, options: [:], completionHandler: nil)
        
    }
    
    
}
