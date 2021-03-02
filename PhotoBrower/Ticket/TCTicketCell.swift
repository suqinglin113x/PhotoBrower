//
//  TCTicketCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/15.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCTicketCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        tipLabel.layer.borderColor = UIColor(red: 1, green: 0.4, blue: 0, alpha: 1).cgColor
        tipLabel.layer.borderWidth = 1
        
    }

    
    
    @IBAction func reserveBtnClick(_ sender: Any) {
       debugPrint("点了预订")
        let orderVC = TCSubmitOrderViewController()
        orderVC.orderSourceType = .ticket
        let currentVC = UIApplication.shared.windows.first?.rootViewController?.children.last
        currentVC?.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    
    func configData(model: TCTicketModel) {
        titleLabel.text = model.resourceName
//        detailInfoLabel.text = ""// 不知道用啥字段
        moneyLabel.text = model.startingPrice
    }
}
