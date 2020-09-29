//
//  TCHotelOrderHotelInfowCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/22.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelOrderHotelInfowCell: UITableViewCell {

    
    @IBOutlet weak var unSubscribeNoticeL: UILabel! // 退订条款
    @IBOutlet weak var reserveNoticeLabel: UILabel! // 预定条款
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = .white
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(showUnSubscribeNotice))
        unSubscribeNoticeL.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(showReserveNotice))
        reserveNoticeLabel.addGestureRecognizer(tap2)
        
    }
    override func layoutSubviews() {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
}

extension TCHotelOrderHotelInfowCell {
    // 退订条件
    @objc private func showUnSubscribeNotice() {
        
    }
    
    // 预定须知
    @objc private func showReserveNotice() {
        let view = TCHotelOrderReserveNoticeView(frame: UIScreen.main.bounds)
        UIApplication.shared.windows[0].addSubview(view)
    }
    
}


private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height

class TCHotelOrderReserveNoticeView: UIView {
    
    
    var bgView: UIView!
    var closeButton: UIButton!
    var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createView()
    }
    
   
    
    private func createView() {
        let bgViewH: CGFloat = kScreenH - 150
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        closeButton = UIButton(frame: CGRect(x: kScreenW-35, y: kScreenH-bgViewH-35, width: 35, height: 35))
        closeButton.setImage(UIImage.init(named: "hotel_order_close_white"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeRemarkView), for: .touchUpInside)
        self.addSubview(closeButton)
        
        bgView = UIView(frame: CGRect(x: 0, y: kScreenH - bgViewH, width: kScreenW, height: bgViewH))
        bgView.backgroundColor = .white
        self.addSubview(bgView)
        let path = UIBezierPath(roundedRect: bgView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bgView.bounds
        maskLayer.path = path.cgPath
        bgView.layer.mask = maskLayer
        
        let titleL = UILabel(frame: CGRect(x: 15, y: 25, width: UIScreen.main.bounds.size.width - 30, height: 16))
        titleL.text = "预定须知"
        titleL.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        bgView.addSubview(titleL)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(5)
            make.leading.trailing.bottom.equalTo(bgView)
        }
    }
    
    
    @objc func closeRemarkView() {
        UIView.animate(withDuration: 0.5) {
            self.closeButton.frame.origin.y = kScreenH
            self.bgView.frame.origin.y = kScreenH
        } completion: { (com) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TCHotelOrderReserveNoticeView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "您需要在酒店支付以下费用：\n破损费押金：15 岁以下住客在 2 月 01 日 - 5 月 08 日期间入住，每次住宿 USD 150 \n该城市征收一项税款，并将由住宿代为收取。可能会有免除或扣减税款的情况。如需更多信息，请通过预订确认邮件中的信息联系住宿。\n将会收取 2 % 的观光浏览费\n将会收取 1.2 % 的目的地附加费……"
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.font = UIFont(name: "PingFangSC-Regular", size: 13)
        cell?.textLabel?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 49
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 49))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 15, y: 25, width: UIScreen.main.bounds.size.width-30, height: 14))
        label.text = "出行人信息"
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont(name: "PingFangSC-Semibold", size: 14)
        view.addSubview(label)
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

