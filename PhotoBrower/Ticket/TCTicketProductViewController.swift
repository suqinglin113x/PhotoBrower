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
    var introItemArr: [(title: String, model: TCIntroItemContentModel, iconStr: String)] = []
    var introItemHeights: [CGFloat] = []
    
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
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewConstraintH: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upImageView: UIImageView!
    
    var hoverOffY: CGFloat?
    lazy var tableHeaderView: TCTicketProductHeader = {
        let headView = Bundle.main.loadNibNamed("TCTicketProductHeader", owner: self, options: nil)?.first as! TCTicketProductHeader
        return headView
    }()
    /// 默认添加俩倒数底部的section
    var sectionTitles: [String] = ["",""]
    /// 简介、须知
    var currentSelectedBtn: UIButton?
    /// 存储简介、须知
    var lastSectionButtonArray: [UIButton] = []
    var lastSectionLineViewArray: [UIView] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        if !isIphoneX {
            self.bottomViewConstraintH.constant -= 34
        }
        self.creatTab()
        self.view.addSubview(self.customNavHeader)
        
        self.getBaseInfoData()
        self.getTicketsData()
        self.getAdBanner()
        self.getCMSData()
        self.getExplainInfo()
    }
    
    func creatTab() {
        tableView.register(UINib(nibName: "TCTicketSectionCell", bundle: nil), forCellReuseIdentifier: "TCTicketSectionCell")
        tableView.register(UINib(nibName: "TCTicketProductCompanyCell", bundle: nil), forCellReuseIdentifier: "TCTicketProductCompanyCell")
        tableView.register(UINib(nibName: "TCTicketProductIntroCell", bundle: nil), forCellReuseIdentifier: "TCTicketProductIntroCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = tableHeaderView
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableHeaderView.refreshHeaderHeight = { height in
            self.tableHeaderView.frame.size.height = height
            self.tableView.tableHeaderView = self.tableHeaderView
        }
        
        let footer = UIView()
        footer.backgroundColor = .white
        footer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180)
        let logoIV = UIImageView(frame: CGRect(x: 0, y: 30, width: 165, height: 70))
        logoIV.center.x = footer.center.x
        logoIV.sd_setImage(with: URL(string: "https://image.fosunholiday.com/tc-fostay/water-mark.png"), placeholderImage: nil, options: [.refreshCached], context: nil)
        footer.addSubview(logoIV)
        tableView.tableFooterView = footer
    }
    
    
}

// MARK: 事件Action
extension TCTicketProductViewController {
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapUpAction(_ sender: Any) {
        debugPrint("点击了up")
        tableView.contentInset = .zero
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
    }
    @IBAction func tapClosetAction(_ sender: Any) {
        debugPrint("点击了橱窗")
        if ticketModelArrays.isEmpty {
            return
        }
        let offH = (tableView.contentInset.top > 0 ? 0: customNavHeader.bounds.height)
        tableView.scrollRectToVisible(CGRect(x: 0, y: tableHeaderView.frame.maxY - offH, width: 10, height: 1), animated: true)
    }
    
    
    @IBAction func contactSellerAction(_ sender: Any) {
        let tel = "tel://\(productModel.baseInfo?.company?.tel ?? "")"
        UIApplication.shared.open(URL(string: tel)!, options: [:], completionHandler: nil)
    }
    @IBAction func tapCollectionAction(_ sender: UIButton) {
        let url = "\(fosunholidayHost)/online/capi/collect/collectOrCancelProduct/\(productID)"
        let parameters: [String: Any] = [:]
        TCNetworkManager.Instance.post(URLString: url, parameters: parameters, success: {  (response) in
            guard let res = response as? [String: Any] else {
                return
            }
            let dictionary = res["data"] as? [String: Any]
            if let iscoll = dictionary?["isCollected"] as? Bool, iscoll {
                sender.setImage(UIImage.init(named: "webview_yellow"), for: .normal)
            } else {
                sender.setImage(UIImage.init(named: "webview_like"), for: .normal)
            }
            
        }) { (error) in
        
        }
    }
    @IBAction func tapShareAction(_ sender: Any) {
//        let shareVC =
        
    }
    
    
    @IBAction func lookticketList(_ sender: Any) {
        if ticketModelArrays.isEmpty {
            return
        }
        let offH = (tableView.contentInset.top > 0 ? 0: customNavHeader.bounds.height)
        tableView.scrollRectToVisible(CGRect(x: 0, y: tableHeaderView.frame.maxY - offH, width: 10, height: 1), animated: true)
    }
}

// MARK: 网络
extension TCTicketProductViewController {
    
    func getBaseInfoData() {
        let url = fosunholidayHost + "/poseidon/online/product/ticket/\(productID)"
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { [weak self] (response) in

            guard let self = self, let res = response as? [String: Any] else {
                return
            }
            if let hasError = res["hasError"] as? Bool, hasError {
                guard let errorMessage = res["errorMessage"] as? String else {
                    return
                }
                GlobalUtils.Instance.showToastAddTo(self.view, title: errorMessage, duration: 1.5)
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
        
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { [weak self] (response) in

            guard let self = self, let res = response as? [String: Any] else {
                return
            }
            if let hasError = res["hasError"] as? Bool, hasError{
                guard let errorMessage = res["errorMessage"] as? String else {
                    return
                }
                GlobalUtils.Instance.showToastAddTo(self.view, title: errorMessage, duration: 1.5)
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
        
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { [weak self] (response) in

            guard let self = self, let res = response as? [String: Any] else {
                return
            }
            if let hasError = res["hasError"] as? Bool, hasError{
                guard let errorMessage = res["errorMessage"] as? String else {
                    return
                }
                GlobalUtils.Instance.showToastAddTo(self.view, title: errorMessage, duration: 1.5)
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
        TCNetworkManager.Instance.post(URLString: url, parameters: dict) {  [weak self] (response) in
            guard let self = self else { return }
            if let res = response as? [String: Any] {
                if let hasError = res["hasError"] as? Bool, hasError{
                    guard let errorMessage = res["errorMessage"] as? String else {
                        return
                    }
                    GlobalUtils.Instance.showToastAddTo(self.view, title: errorMessage, duration: 1.5)
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
        
        TCNetworkManager.init().post(URLString: url, parameters: dict) { [weak self] (response) in
            guard let self = self else { return }
            if let res = response as? [String: Any] {
                if let hasError = res["hasError"] as? Bool, hasError{
                    guard let errorMessage = res["errorMessage"] as? String else {
                        return
                    }
                    GlobalUtils.Instance.showToastAddTo(self.view, title: errorMessage, duration: 1.5)
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
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { [weak self] (response) in
            guard let self = self else { return }
            if let res = response as? [String: Any] {
                if let hasError = res["hasError"] as? Bool, hasError{
                    guard let errorMessage = res["errorMessage"] as? String else {
                        return
                    }
                    GlobalUtils.Instance.showToastAddTo(self.view, title: errorMessage, duration: 1.5)
                    return
                }
                if let data = try? JSONSerialization.data(withJSONObject: res["data"] as Any, options: []) {
                    do {
                        let model = try JSONDecoder().decode(TCIntroModel.self, from: data)
                        let icons = ["ticket_productIntro", "ticket_productUseRule", "ticket_productRemind", "ticket_productBuyNotice"]
                        
                        // 先按UI搞吧
//                        let model1 = TCIntroItemContentModel(title: model.recommended, content: model.recommended)
//                        self.introItemArr.append((model1.title!, model1))
                        
                        let model2 = TCIntroItemContentModel(title: model.recommended, content: model.productIntroduction)
                        self.introItemArr.append((model2.title!, model2, icons[0]))
                        self.introItemHeights.append(0)
                        
                        for (i, itemModel) in model.productReservationInfos.enumerated() {
                            itemModel.productSubReservationInfos?.forEach({ (itemContentModel) in
                                self.introItemArr.append((itemContentModel.title!, itemContentModel, icons[i+1]))
                                self.introItemHeights.append(0)
                            })
                        }
                        
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
            return 65 + 10
        } else { // 简介、须知
            let cellH: CGFloat = introItemHeights[indexPath.row]
            
            return cellH
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
            cell.refreshCellHeight = { [weak self] h in
//                print("-----\(indexPath.row)-----\(h)---\(cell.wkWebView)")
                guard let weakSelf = self else { return }
                if weakSelf.introItemHeights[indexPath.row] > 0 {
                    return
                }
                
                weakSelf.introItemHeights[indexPath.row] = h
               // 建议莫用indexpath.section
                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: weakSelf.sectionTitles.count-1)], with: .top)
                
            }
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
            lastSectionButtonArray.removeAll()
            lastSectionLineViewArray.removeAll()
            for i in 0..<2 {
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: w*CGFloat(i), y: 0, width: w, height: h)
                btn.setTitle(btnTitles[i], for: .normal)
                btn.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
                btn.addTarget(self, action: #selector(clickIntroOrNotice), for: .touchUpInside)
                btn.titleLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 13)
                lastSectionButtonArray.append(btn)
                headerFooterView.addSubview(btn)
                let lineView = UIView(frame: CGRect(x: btn.frame.origin.x, y: h-2, width: w, height: 2))
                lineView.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
                lastSectionLineViewArray.append(lineView)
                headerFooterView.addSubview(lineView)
                if i == 1 {
                    lineView.isHidden = true
                } else {
                    currentSelectedBtn = btn
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
    
    
    @objc func clickIntroOrNotice(btn: UIButton) {
        self.tableView.contentInset = UIEdgeInsets(top: customNavHeader.bounds.height, left: 0, bottom: 0, right: 0)
        if btn == lastSectionButtonArray.first {
            tableView.scrollToRow(at: IndexPath(row: 0, section: sectionTitles.count-1), at: .top, animated: true)
        }
        if btn == lastSectionButtonArray.last {
            tableView.scrollToRow(at: IndexPath(row: introItemArr.count-1, section: sectionTitles.count-1), at: .bottom, animated: true)
        }
        currentSelectedBtn = btn
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
        // 一键回到顶部
        upImageView.isHidden = (offY < UIScreen.main.bounds.height)
        
        let head = self.tableView.headerView(forSection: sectionTitles.count-1)
        if hoverOffY == nil && head != nil {
            hoverOffY = (head?.frame.origin.y)!
        }
//        print("偏移\(offY)++++\(hoverOffY)")
        if hoverOffY != nil {
            if offY >= (hoverOffY!-customNavHeader.frame.maxY) {
                // 给它点底部距离
                self.tableView.contentInset = UIEdgeInsets(top: customNavHeader.frame.maxY, left: 0, bottom: 0, right: 0)
    
                // 处理简介、须知状态自动切换
                if let _ = tableView.cellForRow(at: IndexPath(row: introItemArr.count-1, section: sectionTitles.count-1)) as? TCTicketProductIntroCell {
//                    debugPrint(lastcell)
                    lastSectionLineViewArray.first?.isHidden = true
                    lastSectionLineViewArray.last?.isHidden = false
                    currentSelectedBtn = lastSectionButtonArray.last
                } else {
                    lastSectionLineViewArray.first?.isHidden = false
                    lastSectionLineViewArray.last?.isHidden = true
                    currentSelectedBtn = lastSectionButtonArray.first
                }
        
            } else {
                self.tableView.contentInset = UIEdgeInsets.zero
            }
        }
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        
        return false
    }
}
