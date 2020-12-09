//
//  TCTicketProductViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/7.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
import SDCycleScrollView

private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
private let isIphoneX = (kScreenH >= 812)

class TCTicketProductViewController: UIViewController {
    var navTitle: String? = "标题"
    var productID: String = "90000023"
    var productModel = TCTicketProductModel()
    
    var statusH: CGFloat = {
        var statusH: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusH = (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
        } else {
            statusH = UIApplication.shared.statusBarFrame.height
        }
        return statusH
    }()
    
    var backButton: UIButton!
    var titleL: UILabel!
    lazy var customNavHeader: UIView = {
        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: kScreenW, height: isIphoneX ? statusH + 44 : statusH + 44)
        navHeader.backgroundColor = .clear
        navHeader.alpha = 1
        backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: statusH, width: 44, height: 44)
        backButton.setImage(UIImage.init(named: "back_white"), for: .normal)
        backButton.addTarget(self,action:#selector(closeVC),for:.touchUpInside)
        backButton.alpha = 1
        navHeader.addSubview(backButton)
        
        titleL = UILabel()
        titleL.frame = CGRect(x: 0, y: backButton.frame.origin.y, width: kScreenW - 44*2, height: 44)
        titleL.center = CGPoint(x: kScreenW * 0.5, y: backButton.center.y)
        titleL.text = self.navTitle
        titleL.textColor = .black
        titleL.isHidden = true
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        navHeader.addSubview(titleL)
        
        return navHeader
    }()
    
    lazy var cycleView: SDCycleScrollView = {
        let cycleView = SDCycleScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
        cycleView.placeholderImage = UIImage.init(named: "image_square_default")
        cycleView.autoScroll = true
        return cycleView
    }()
    
    var tableView: UITableView!
    var hoverOffY: CGFloat?
    lazy var tableHeaderView: UIView = {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: cycleView.bounds.height+325))
        headView.addSubview(cycleView)
        headView.backgroundColor = .red
        return headView
    }()
    /// 默认俩倒数底部的section
    var sectionTitles: [String] = ["",""]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        
        self.creatTab()
        self.view.addSubview(self.customNavHeader)
        
        self.getBaseInfoData()
        self.getTicketsData()
    }
    
    func creatTab() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.backgroundColor = .yellow
        
        self.tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = tableHeaderView
    }

    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: 网络
extension TCTicketProductViewController {
    
    func getBaseInfoData() {
        let url = "https://admintest.fosunholiday.com/online/product/ticket/\(productID)/baseInfo"
        
        TCNetworkManager.Instance.getWithSwiftyJSONResponse(URLString: url, parameters: nil) { (response) in
            debugPrint(response)
            if response["hasError"].boolValue == true {
                
                return
            }
            let baseInfo = TCBaseInfo.init(jsonData: response["data"])
            self.productModel.baseInfo = baseInfo
            
            self.cycleView.imageURLStringsGroup = baseInfo.productImageInfos?.map({$0.url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) as Any})
            self.tableView.reloadData()
            
        } failure: { (error) in
            
        }
    }
    
    /// 门票data
    func getTicketsData() {
        let url = "https://admintest.fosunholiday.com/online/product/ticket/\(productID)/ticketResource"
        
        TCNetworkManager.Instance.getWithSwiftyJSONResponse(URLString: url, parameters: nil) { (response) in
            debugPrint(response)
            if response["hasError"].boolValue == true {
                return
            }
            let dataArr = response["data"].arrayValue
            
            var temArr: [String] = []
            for item in dataArr {
                temArr.append(item["ticketName"].stringValue)
                self.productModel.ticketModelArray?.append(TCTicketModel.arrWith(jsonData: item["resources"]))
            }
            self.sectionTitles.insert(contentsOf: temArr, at: 0)
            self.tableView.reloadData()
            
        } failure: { (error) in
            
        }
    }
}


extension TCTicketProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sectionTitles.count-1 {
            return 10
        }
        return 3
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == sectionTitles.count-1 {
            return 51
        }
        if section == sectionTitles.count-2 {
            return 20
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(indexPath.section)-\(indexPath.row)"
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var h: CGFloat = 45
        if section == sectionTitles.count-2 {
            h = 20
        }
        let headerFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: h))
        headerFooterView.contentView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        if section == sectionTitles.count-1 {
            h = 51
            headerFooterView.contentView.backgroundColor = .white
            let btnTitles = ["简介", "须知"]
            let w = UIScreen.main.bounds.width/2
            for i in 0..<2 {
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: w*CGFloat(i), y: 0, width: w, height: h)
                btn.setTitle(btnTitles[i], for: .normal)
                btn.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
                btn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 13)
                headerFooterView.addSubview(btn)
            }
            
        } else {
            let titleL = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: h))
            titleL.font = UIFont(name: "PingFangSC-Semibold", size: 15)
            titleL.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            headerFooterView.addSubview(titleL)
            titleL.text = sectionTitles[section]
            
        }
    
        return headerFooterView
    }
}


extension TCTicketProductViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offY = scrollView.contentOffset.y
        if offY > 0 && offY <= customNavHeader.frame.maxY {
            let alpha = offY/customNavHeader.frame.maxY
            customNavHeader.alpha = alpha
            customNavHeader.backgroundColor = .white
            titleL.isHidden = false
            backButton.setImage(UIImage.init(named: "back_black"), for: .normal)
        } else if offY <= 0 {
            customNavHeader.backgroundColor = .clear
            customNavHeader.alpha = 1
            titleL.isHidden = true
            backButton.setImage(UIImage.init(named: "back_white"), for: .normal)
        } else {
            customNavHeader.backgroundColor = .white
            customNavHeader.alpha = 1
            titleL.isHidden = false
            backButton.setImage(UIImage.init(named: "back_black"), for: .normal)
        }
        
        let head = self.tableView.headerView(forSection: sectionTitles.count-1)
        if hoverOffY == nil && head != nil {
            hoverOffY = (head?.frame.maxY)! - (head?.bounds.height)!
        }
        
        if hoverOffY != nil {
            if offY >= (hoverOffY!-customNavHeader.frame.maxY) {
                self.tableView.contentInset = UIEdgeInsets(top: customNavHeader.frame.maxY, left: 0, bottom: 0, right: 0)
            } else {
                self.tableView.contentInset = UIEdgeInsets.zero
            }
        }
    }
}
