//
//  TCIMCustomerCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/3/16.
//  Copyright © 2021 苏庆林. All rights reserved.
// kkkk

import UIKit

class TCIMCustomerCell: UITableViewCell {
    private var icon: UIImageView!
    private var stack: UIStackView!
    private var nameL: UILabel!
    private var contactButton: UIButton!
    private var timeL: UILabel!
    private var line: UIView!
    private var customerModel: TCIMCustomerModel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.createSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubView() {
        icon = UIImageView()
        icon.image = UIImage.init(named: "user_nologin")
        self.contentView.addSubview(icon)
        
        stack = UIStackView()
        stack.spacing = 5
        stack.axis = .vertical
        contentView.addSubview(stack)
        
        nameL = UILabel()
        nameL.textColor = .black
        nameL.font = UIFont(name: "PingFangSC-Regular", size: 15)
        stack.addArrangedSubview(nameL)
        
        contactButton = UIButton(type: .custom)
        contactButton.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.5725490196, blue: 1, alpha: 1)
        contactButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
        contactButton.setTitleColor(.white, for: .normal)
        contactButton.setTitle("联系TA", for: .normal)
        contactButton.layer.cornerRadius = 3
        contactButton.addTarget(self, action: #selector(toChatRoomVC), for: .touchUpInside)
        contentView.addSubview(contactButton)
        
        timeL = UILabel()
        timeL.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        timeL.font = UIFont(name: "PingFangSC-Regular", size: 11)
        stack.addArrangedSubview(timeL)
        
        line = UIView()
        line.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        self.contentView.addSubview(line)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width: CGFloat = self.contentView.bounds.width
        let height: CGFloat = self.contentView.bounds.height
        let margin: CGFloat = 15
        
        icon.frame = CGRect(x: margin, y: 0, width: 45, height: 45)
        icon.center.y = self.contentView.center.y
        icon.layer.cornerRadius = icon.bounds.width*0.5
        icon.layer.masksToBounds = true
        
        contactButton.frame = CGRect(x: width-margin-60, y: 0, width: 60, height: 30)
        contactButton.center.y = self.contentView.center.y
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: margin),
            stack.trailingAnchor.constraint(equalTo: contactButton.leadingAnchor, constant: -margin),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
        ])
        
        nameL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameL.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            nameL.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            nameL.heightAnchor.constraint(equalToConstant: 20)
        ])
        timeL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeL.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            timeL.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            timeL.heightAnchor.constraint(equalToConstant: 15)
        ])
        line.frame = CGRect(x: stack.frame.minX, y: height - 0.5, width: width-stack.frame.minX, height: 0.5)
    }
    
    func configData(model: TCIMCustomerModel) {
        customerModel = model
        nameL.text = model.name
        if let time = model.lastMessageTime, !time.isEmpty {
            timeL.text = "最近联系 \(time)"
            timeL.isHidden = false
        } else {
            timeL.isHidden = true
        }
        
        if let url = model.avatarUrl {
            icon.sd_setImage(with: URL(string: url), completed: nil)
        }
        
       
    }
    
    @objc func toChatRoomVC() {
        debugPrint("进到聊天室")
//        let cellData = TUIConversationCellData()
//        if let userId = customerModel.timId {
//            cellData.userID = userId
//            let vc = TCChatViewController(cellData)
//            let currentVC = UIApplication.shared.windows.first?.rootViewController?.children.last
//            currentVC?.navigationController?.pushViewController(vc, animated: true)
//        }
        
        
    }
}
