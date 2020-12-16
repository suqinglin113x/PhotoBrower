//
//  TCTicketSectionCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/15.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCTicketSectionCell: UITableViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var moreTipLabel: UILabel!
    @IBOutlet weak var moreIcon: UIImageView!
    @IBOutlet weak var moreViewConstraintH: NSLayoutConstraint!
    
    var isOpen: Bool = false
    var showMoreBlock: ((_ section: Int,_ open: Bool) -> ())?
    
    var ticketModelArr: (eachModelArr: [TCTicketModel], isOpen: Bool) = ([],false) {
        didSet {
            if ticketModelArr.eachModelArr.count <= 3 {
                moreView.isHidden = true
                moreViewConstraintH.constant = 0
                
            } else {
                moreView.isHidden = false
                moreViewConstraintH.constant = 40
            }
            self.isOpen = ticketModelArr.isOpen
            updateOpenStatus()
            self.tableView.reloadData()
        }
    }
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 0)
        tableView.layer.shadowRadius = 5
        tableView.layer.shadowOpacity = 0.1
        tableView.layer.masksToBounds = false
        tableView.layer.cornerRadius = 5
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TCTicketCell", bundle: nil), forCellReuseIdentifier: "TCTicketCell")
        
        let moreTap = UITapGestureRecognizer(target: self, action: #selector(showMoreTicket))
        moreView.addGestureRecognizer(moreTap)
        
    }

    /// 刷新更多、收起状态
    func updateOpenStatus()  {
        if isOpen {
            moreTipLabel.text = "收起"
            moreIcon.image = UIImage.init(named: "ticket_up")
        } else {
            moreTipLabel.text = "展开更多"
            moreIcon.image = UIImage.init(named: "ticket_down")
        }
    }
    @objc func showMoreTicket(tap: UIGestureRecognizer) {
        
        debugPrint("展示更多点击")
        if showMoreBlock != nil {
            isOpen = !isOpen
            showMoreBlock!(section!, isOpen)
            
            updateOpenStatus()
        }
    }
    
}


extension TCTicketSectionCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCTicketCell") as! TCTicketCell
        cell.configData(model: ticketModelArr.eachModelArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ticketModelArr.eachModelArr.count > 3 && ticketModelArr.isOpen == false {
            return 3
        } else {
            return ticketModelArr.eachModelArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
