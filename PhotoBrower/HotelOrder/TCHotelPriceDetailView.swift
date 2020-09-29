//
//  TCHotelPriceDetailView.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/29.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height

class TCHotelPriceDetailView: UIView {

    var dataSource: [String]? = []
    
    var bgView: UIView!
    var closeButton: UIButton!
    var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createView()
    }
    
   
    
    private func createView() {
        let bgViewH: CGFloat = 300
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
        titleL.text = "价格明细"
        titleL.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        bgView.addSubview(titleL)
        
        let line = UIView(frame: CGRect(x: 15, y: bgViewH-84, width: kScreenW-30, height: 1))
        line.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        bgView.addSubview(line)
        
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        bgView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(line.snp.top)
        }
        
        let label = UILabel()
        label.text = "在线支付总价"
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont(name: "PingFangSC-Regular", size: 13)
        bgView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalTo(bgView).offset(15)
            make.top.equalTo(line.snp.bottom).offset(18)
            make.height.equalTo(13)
        }
        
        let allPriceL = UILabel()
        allPriceL.text = "¥3309.00"
        allPriceL.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        allPriceL.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        bgView.addSubview(allPriceL)
        allPriceL.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgView).offset(-15)
            make.top.equalTo(label.snp.top).offset(0)
            make.height.equalTo(16)
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


extension TCHotelPriceDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "房晚价格"
        cell?.textLabel?.font = UIFont(name: "PingFangSC-Regular", size: 13)
        cell?.textLabel?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        cell?.detailTextLabel?.text = "¥2000.00"
        cell?.detailTextLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 13)
        cell?.detailTextLabel?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
