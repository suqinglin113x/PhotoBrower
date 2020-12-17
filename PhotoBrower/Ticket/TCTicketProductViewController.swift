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
    var navTitle: String? = ""
    var productID: String = "90000023"//90000030
    var productModel = TCTicketProductModel()
    var ticketModelArrays:[(eachModelArr: [TCTicketModel], isOpen: Bool)] = []
    var introItemArr: [(title: String, model: TCIntroItemContentModel)] = []
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
        titleL.textColor = .black
        titleL.isHidden = true
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        navHeader.addSubview(titleL)
        
        return navHeader
    }()
    
    
    var tableView: UITableView!
    var hoverOffY: CGFloat?
    lazy var tableHeaderView: TCTicketProductHeader = {
        let headView = Bundle.main.loadNibNamed("TCTicketProductHeader", owner: self, options: nil)?.first as! TCTicketProductHeader
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
        self.getAdBanner()
        self.getCMSData()
        self.getExplainInfo()
    }
    
    func creatTab() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        tableView.register(UINib(nibName: "TCTicketSectionCell", bundle: nil), forCellReuseIdentifier: "TCTicketSectionCell")
        tableView.register(UINib(nibName: "TCTicketProductCompanyCell", bundle: nil), forCellReuseIdentifier: "TCTicketProductCompanyCell")
        tableView.register(UINib(nibName: "TCTicketProductIntroCell", bundle: nil), forCellReuseIdentifier: "TCTicketProductIntroCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = tableHeaderView
//        tableView.separatorStyle = .none
        tableHeaderView.refreshHeaderHeight = { height in
            self.tableHeaderView.frame.size.height = height
            self.tableView.tableHeaderView = self.tableHeaderView
        }
    }

    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: 网络
extension TCTicketProductViewController {
    
    func getBaseInfoData() {
        let url = fosunholidayHost + "/poseidon/online/product/ticket/\(productID)"
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { (response) in

            guard let res = response as? [String: Any] else {
                return
            }
            let hasError = res["hasError"] as! Int
            if hasError != 0 {
                return
            }
        
            if let jsonData = try? JSONSerialization.data(withJSONObject: res["data"] as Any, options: []) {
                do {
                    var baseInfo: TCBaseInfo = try JSONDecoder().decode(TCBaseInfo.self, from: jsonData)
                    baseInfo.productCode = self.productID
                    self.productModel.baseInfo = baseInfo
                    self.titleL.text = baseInfo.productName
                    self.tableHeaderView.configBaseInfoData(baseInfo: baseInfo)
                    self.getCouponData()
                    self.tableView.reloadData()
                } catch  {
                    print(error)
                }
            }
            
        } failure: { (error) in
            
        }

    }
    
    /// 门票data
    func getTicketsData() {
        let url = fosunholidayHost + "/poseidon/online/product/\(productID)/ticketResource"
        
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { (response) in

            guard let res = response as? [String: Any] else {
                return
            }
            let hasError = res["hasError"] as! Bool
            if hasError {
                return
            }
            if let dataArr = res["data"] as? [[String : Any]] {
                var temArr: [String] = []
                for (_, item) in dataArr.enumerated() {
                    temArr.append(item["ticketName"] as? String ?? "")
                    let eachModelArr = TCTicketModel.arrWith(dataArr: item["resources"] as Any)

                    self.ticketModelArrays.append((eachModelArr, false))
                }
                self.sectionTitles.insert(contentsOf: temArr, at: 0)
                self.tableView.reloadData()
            }
            
           
            
        } failure: { (error) in
            
        }
    }
    
    // 广告banner
    func getAdBanner() {
        let url = fosunholidayHost + "/online/capi/component/getExtensionInfo/\(productID)"
        
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { (response) in

            guard let res = response as? [String: Any] else {
                return
            }
            let hasError = res["hasError"] as! Bool
            if hasError {
                return
            }
            if let bannerS = res["data"] as? [String: Any] {
                if let data = try? JSONSerialization.data(withJSONObject: bannerS["extension"] as Any, options: []) {
                    let model = try? JSONDecoder().decode(TCAdBannerModel.self, from: data)

                    self.tableHeaderView.configAdBannerData(model: model ?? TCAdBannerModel())
                }
                self.tableView.reloadData()
            }
        } failure: { (error) in
            
        }
    }
    
    /// CMS
    func getCMSData() {
        let url = fosunholidayHost+"/online/cms-api/pageComponents"
        let dict = ["codes":["TCH5_Product_Service_commitment", "TCH5_Product_Service_copywriting"]]
        TCNetworkManager.Instance.post(URLString: url, parameters: dict) { (response) in
            if let res = response as? [String: Any] {
                let hasError = res["hasError"] as! Bool
                if hasError {
                    return
                }
                let pageComponents = (res["data"] as! NSDictionary)["pageComponents"]
                let arr = TCCMSModel.arrWith(dataArr: pageComponents as Any)
                self.tableHeaderView.configCmsData(arr)
            }
            
            
        } failure: { (error) in
            
        }
    }
    
    // 优惠券
    func getCouponData() {
        let url = fosunholidayHost+"/online/capi/cp/getAvailableCouponList"
        let dict = ["appKey": "APP_TC",
                    "categoryId": productModel.baseInfo?.productType as Any,
                    "companyId": productModel.baseInfo?.company?.companyId as Any,
                    "productId": productID] as [String : Any]
        
        TCNetworkManager.init().post(URLString: url, parameters: dict) { (response) in

            if let res = response as? [String: Any] {
                let hasError = res["hasError"] as! Bool
                if hasError {
                    return
                }
                let cpInfoDTOS = (res["data"] as? [String: Any])?["cpInfoDTOS"]
                
                let arr = TCCouponModel.arrWith(dataArr: cpInfoDTOS as Any)
                
                self.tableHeaderView.configCouponData(couponArr: arr)
                
            }
        } failure: { (error) in
            
        }
    }
    
    /// 简介/须知等
    func getExplainInfo() {
        let url = fosunholidayHost+"/poseidon/online/product/ticket/\(productID)/explaininfo"
        
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { (response) in
            if let res = response as? [String: Any] {
                let hasError = res["hasError"] as! Bool
                if hasError {
                    return
                }
                if let data = try? JSONSerialization.data(withJSONObject: res["data"] as Any, options: []) {
                    do {
                        let model = try JSONDecoder().decode(TCIntroModel.self, from: data)
                        
                        // UI搞不懂设计的球
                        let model1 = TCIntroItemContentModel(title: model.recommended, content: model.recommended)
                        self.introItemArr.append((model1.title!, model1))
                        let model2 = TCIntroItemContentModel(title: model.recommended, content: model.productIntroduction)
                        self.introItemArr.append((model2.title!, model2))
                        
                        model.productReservationInfos?.forEach({ (itemModel) in
                            itemModel.productSubReservationInfos?.forEach({ (itemContentModel) in
                                self.introItemArr.append((itemContentModel.title!, itemContentModel))
                            })
                        })
                        self.tableView.reloadData()
                        
                    } catch {
                        debugPrint(error)
                    }
                    
                }
                
            }
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
            return introItemArr.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == sectionTitles.count-2 {
            return 20
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section < ticketModelArrays.count { // 买票
            let itemH: CGFloat = 70
            var bottomSpace: CGFloat = 0
            var eachRows = ticketModelArrays[indexPath.section].eachModelArr.count
            if eachRows > 3 {
                bottomSpace = 40
            } else {
                bottomSpace = 10
            }
            if eachRows > 3 && ticketModelArrays[indexPath.section].isOpen == false {
                eachRows = 3
                return itemH * CGFloat(eachRows) + bottomSpace
            }
            return itemH * CGFloat(eachRows) + bottomSpace
        } else if indexPath.section == sectionTitles.count-2 { // 公司信息
            return 65+10
        } else { // 简介/须知
            return 200
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < ticketModelArrays.count { // 买票
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCTicketSectionCell") as! TCTicketSectionCell
            cell.section = indexPath.section
            cell.ticketModelArr = ticketModelArrays[indexPath.section]
            cell.showMoreBlock = { (section, isOpen) in
                self.ticketModelArrays[section].isOpen = isOpen
                self.tableView.reloadData()
            }
            return cell
        } else if indexPath.section == sectionTitles.count-2 { // 公司信息
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCTicketProductCompanyCell") as! TCTicketProductCompanyCell
            cell.baseInfo = productModel.baseInfo
            return cell
        } else { // 简介/须知
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCTicketProductIntroCell") as! TCTicketProductIntroCell
            cell.configData(data: introItemArr[indexPath.row])
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var h: CGFloat = 45
        if section == ticketModelArrays.count {
            h = 20
        }
        let headerFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: h))
        headerFooterView.contentView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        if section == sectionTitles.count-1 {
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
                let lineView = UIView(frame: CGRect(x: 0, y: h-2, width: w, height: 2))
                lineView.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
                headerFooterView.addSubview(lineView)
                if i == 1 {
                    lineView.isHidden = true
                } else {
                    
                }
                
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
                // 给它点底部距离，好看
                self.tableView.contentInset = UIEdgeInsets(top: customNavHeader.frame.maxY, left: 0, bottom: 30, right: 0)
            } else {
                self.tableView.contentInset = UIEdgeInsets.zero
            }
        }
    }
}
