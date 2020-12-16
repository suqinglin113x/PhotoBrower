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
    
    var isOpen: Bool = false
    var showMoreBlock: ((_ section: Int,_ open: Bool) -> ())?
    
    var ticketModelArr: (eachModelArr: [TCTicketModel], isOpen: Bool) = ([],false) {
        didSet {
            moreView.isHidden = (ticketModelArr.eachModelArr.count <= 3)
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
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TCTicketCell", bundle: nil), forCellReuseIdentifier: "TCTicketCell")
        
        
        let moreTap = UITapGestureRecognizer(target: self, action: #selector(showMoreTicket))
        moreView.addGestureRecognizer(moreTap)
        
    }

    @objc func showMoreTicket(tap: UIGestureRecognizer) {
        
        debugPrint("展示更多点击")
        if showMoreBlock != nil {
            isOpen = !isOpen
            showMoreBlock!(section!, isOpen)
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
