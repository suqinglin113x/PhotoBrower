//
//  TCHotelOrderPayTypeCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/28.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

/// 支付渠道：微信、支付宝
enum OrderPayType: Int {
    /// 暂无支付
    case none
    /// 微信支付
    case weixinPay
    /// 支付宝支付
    case aliPay
}
class TCHotelOrderPayTypeCell: UITableViewCell {
    
    @IBOutlet weak var weixinPayView: UIView!
    @IBOutlet weak var weixinPayIV: UIImageView!
    @IBOutlet weak var aliPayView: UIView!
    @IBOutlet weak var alipayIV: UIImageView!
    // 可选隐藏
    @IBOutlet weak var clauseButton: UIButton!
    var choosedPayType: OrderPayType?
    /// 选完支付方式完成
    var choosePayTypeComplete: ((_ payType: OrderPayType) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapWeixin = UITapGestureRecognizer(target: self, action: #selector(chooseWeixinPay))
        weixinPayView.addGestureRecognizer(tapWeixin)
        
        let tapAlipay = UITapGestureRecognizer(target: self, action: #selector(chooseAliPay))
        aliPayView.addGestureRecognizer(tapAlipay)
    }

    @objc private func chooseWeixinPay() {
        weixinPayIV.image = UIImage.init(named: "hotel_order_paySele")
        alipayIV.image = UIImage.init(named: "hotel_order_payNoSele")
        choosedPayType = .weixinPay
        if choosePayTypeComplete != nil {
            choosePayTypeComplete!(choosedPayType ?? .none)
        }
    }
    
    @objc private func chooseAliPay() {
        weixinPayIV.image = UIImage.init(named: "hotel_order_payNoSele")
        alipayIV.image = UIImage.init(named: "hotel_order_paySele")
        choosedPayType = .aliPay
        if choosePayTypeComplete != nil {
            choosePayTypeComplete!(self.choosedPayType ?? .none)
        }
    }
    
    @IBAction func showClauseView(_ sender: Any) {
        debugPrint("点击跳转到Expedia的H5页面。非Expedia酒店不展示预订条款。")
    }
}
