//
//  TCHotelCommentListController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/21.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

private let isIphoneX = ((UIScreen.main.bounds.size.height >= 812) ? true : false)

class TCHotelCommentListController: UIViewController {

    var navTitle: String?
    var statusH: CGFloat = {
        var statusH: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusH = (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
        } else {
            statusH = UIApplication.shared.statusBarFrame.height
        }
        return statusH
    }()
    lazy var customNavHeader: UIView = {
        
        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: isIphoneX ? statusH + 44 : statusH + 44)
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: statusH, width: 44, height: 44)
        backButton.setImage(UIImage.init(named: "back_black"), for: .normal)
        backButton.addTarget(self,action:#selector(closeVC),for:.touchUpInside)
        navHeader.addSubview(backButton)
        
        let titleL = UILabel()
        titleL.frame = CGRect(x: 0, y: backButton.frame.origin.y, width: view.bounds.size.width - 44*2, height: 44)
        titleL.center = CGPoint(x: view.bounds.size.width*0.5, y: backButton.center.y)
        titleL.text = self.navTitle
        titleL.textColor = .black
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        navHeader.addSubview(titleL)
        
        return navHeader
    }()
    
    lazy var tableView: UITableView! = {
        let tab = UITableView(frame: .zero, style: .plain)
        let topY: CGFloat = isIphoneX ? statusH + 44 : statusH + 44
        tab.frame = CGRect(x: 0.0, y: topY, width: view.bounds.size.width, height: view.bounds.size.height - topY)
        tab.delegate = self
        tab.dataSource = self
        tab.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 28 + 35, right: 0)
        tab.register(UINib(nibName: "TCHotelCommentCell", bundle: Bundle.main), forCellReuseIdentifier: "TCHotelCommentCell")
        return tab
    }()
    
    var commentListArray: [String]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(customNavHeader)
        self.view.addSubview(tableView)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 30, y: view.bounds.size.height - 28 - 35, width: view.bounds.width - 60, height: 35)
        btn.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
        btn.layer.cornerRadius = 17
        btn.setTitle("返回查看房型", for: .normal)
        btn.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 13)
        btn.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        self.view.addSubview(btn)
        
        let header: TCHotelCommentHeaderView = Bundle.main.loadNibNamed("TCHotelCommentHeaderView", owner: nil, options: nil)?.first as! TCHotelCommentHeaderView
        header.configWithData()
        tableView.tableHeaderView = header
        
        self.getCommentList()
    }
    
}

extension TCHotelCommentListController {
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func  getCommentList() {
        for _ in 0...15 {
            commentListArray?.append("早餐非常丰富中西法日多个菜系都包括了。因为还处于疫情防控期间酒店内控制方式非常好。安全又人性化。常丰富中西法日菜系都包括了。因为还处于疫情防控多个菜系都包括了。因为还")
        }
        
        tableView.reloadData()
    }
}

extension TCHotelCommentListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentListArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TCHotelCommentCell") as! TCHotelCommentCell
        cell.configModel(model: commentListArray?[indexPath.row] ?? "")
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let contenH = TCHotelCommentCell.getCellHeight(model: commentListArray?[indexPath.row] ?? "")
        return contenH + 136 - 36
    }
    
    
    
}




