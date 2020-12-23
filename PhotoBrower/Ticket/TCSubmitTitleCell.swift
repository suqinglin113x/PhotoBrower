//
//  TCSubmitTitleCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/22.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

private let kScreenW: CGFloat = UIScreen.main.bounds.width
class TCSubmitTitleCell: UITableViewCell {

    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        titleLabel.font = UIFont(name: "PingFangSC-Semibold", size: 18)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.leading.equalTo(15)
            make.bottom.equalTo(-15)
            make.trailing.equalTo(-15)
        }
        let lineView = UIView()
        lineView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
