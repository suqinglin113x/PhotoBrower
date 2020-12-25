//
//  TCSubmitOrderInfosCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/23.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

private let kScreenW: CGFloat = UIScreen.main.bounds.width


class TCSubmitOrderInfosCell: UITableViewCell {

    var presaleNumChanged: ((_ num: Int) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
    }

    
    /// 门票、自由行UI-Data
    func configData(items: [(title: String, subTitle: String)], type: OrderSourceType, orderName: String = "") {
        self.contentView.subviews.forEach({$0.removeFromSuperview()})
        var y: CGFloat = 0
        if type == .ticket {
            y = 43
            
            let label = UILabel()
            label.frame = CGRect(x: 15, y: 14, width: kScreenW-30, height: 14)
            label.text = orderName
            label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            label.font = UIFont(name: "PingFangSC-Medium", size: 14)
            self.contentView.addSubview(label)
        }
        if type == .travel {
            y = 14
        }
        let itemW: CGFloat = kScreenW/2
        let itemH: CGFloat = 13
        let space: CGFloat = 10
        
        for i in 0..<items.count {
            let label1 = UILabel()
            label1.frame = CGRect(x: 15, y: y + (itemH+space) * CGFloat(i), width: itemW, height: itemH)
            label1.text = items[i].title
            label1.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            label1.font = UIFont(name: "PingFangSC-Regular", size: 13)
            self.contentView.addSubview(label1)
            
            let label2 = UILabel()
            label2.frame = CGRect(x: kScreenW - 15-itemW, y: y + (itemH+space) * CGFloat(i), width: itemW, height: itemH)
            label2.text = items[i].subTitle
            label2.textAlignment = .right
            label2.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            label2.font = UIFont(name: "PingFangSC-Semibold", size: 13)
            self.contentView.addSubview(label2)
        }
    }
    
    /// 预售UI-Data
    func configPresaleData(data: [(title: String, subTitle: String)]) {
        self.contentView.subviews.forEach({$0.removeFromSuperview()})
        let titleL = UILabel()
        titleL.frame = CGRect(x: 15, y: 14, width: kScreenW-30, height: 14)
        titleL.text = data.first?.title
        titleL.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        titleL.font = UIFont(name: "PingFangSC-Medium", size: 14)
        self.contentView.addSubview(titleL)
        
        let declareL = UILabel()
        declareL.frame = CGRect(x: 15, y: titleL.frame.maxY+10, width: kScreenW-30, height: 14)
        declareL.text = data[1].title
        declareL.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        declareL.font = UIFont(name: "PingFangSC-Regular", size: 11)
        self.contentView.addSubview(declareL)
        
        let priceL = UILabel()
        priceL.frame = CGRect(x: 15, y: declareL.frame.maxY + 15, width: 150, height: 25)
        priceL.text = "￥439322.09"
        priceL.textColor = UIColor(red: 1, green: 0.4, blue: 0, alpha: 1)
        priceL.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        self.contentView.addSubview(priceL)
        
        let counterView = TCCounterView(frame: CGRect(x: kScreenW - 15 - 100, y: priceL.frame.minY, width: 100, height: priceL.bounds.height))
        counterView.currentNum = Int(data.last?.subTitle ?? "1") ?? counterView.defaultMin
        self.contentView.addSubview(counterView)
        counterView.counterViewChangedBlock = { [weak self] num in
            guard let self = self else {
                return
            }
            if self.presaleNumChanged != nil {
                self.presaleNumChanged!(num)
            }
            debugPrint(num)
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
