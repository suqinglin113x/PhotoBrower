//
//  TCIMCustomerViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/3/16.
//  Copyright © 2021 苏庆林. All rights reserved.
//

import UIKit
import MJRefresh

private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
private let isIphoneX = (kScreenH >= 812)

class TCIMCustomerViewController: UIViewController {
    var advisorId: String = "8011251"
    private var tableView: UITableView!
    var dataSource: [TCIMCustomerModel] = []
    var pageNo: Int = 1
    
    var navTitle: String? = "咨询客户管理"
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
        
        backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: statusH, width: 44, height: 44)
        backButton.setImage(UIImage.init(named: "back_black"), for: .normal)
        backButton.addTarget(self,action:#selector(closeVC),for:.touchUpInside)
        navHeader.addSubview(backButton)
        
        titleL = UILabel()
        titleL.frame = CGRect(x: 0, y: backButton.frame.origin.y, width: kScreenW - 44*2, height: 44)
        titleL.center = CGPoint(x: kScreenW * 0.5, y: backButton.center.y)
        titleL.text = self.navTitle
        titleL.textColor = .black
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        navHeader.addSubview(titleL)
        
        return navHeader
    }()
    private var noticeView: TCPayResultNoticeView?
    private var messageTipViewH: CGFloat = 25
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.view.addSubview(customNavHeader)
        
        self.loadNoticeViewData { [unowned self] in
            self.createTableView()
        }
        self.loadData()
    }
    
    
    func createTableView() {
        if noticeView == nil {
            messageTipViewH = 0
        }
        tableView = UITableView(frame: CGRect(x: 0, y: customNavHeader.frame.maxY+messageTipViewH, width: kScreenW, height: kScreenH-customNavHeader.frame.maxY), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TCIMCustomerCell.self, forCellReuseIdentifier: "TCIMCustomerCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.pageNo = 1
            self.loadData()
        })
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.pageNo += 1
            self.loadData()
        })
    }
    
    
    func addNoticeView(messages: [String]) {
        noticeView = TCPayResultNoticeView(frame: CGRect(x: 0, y: customNavHeader.frame.maxY, width: UIScreen.main.bounds.width, height: messageTipViewH), messages: messages)
        noticeView?.textLeftMargin = 20
        self.view.addSubview(noticeView!)
        noticeView?.closeActionClicked = { [weak self] in
            guard let self = self else { return }
            self.tableView.frame.origin.y -= (self.noticeView?.bounds.height)!
        }
    }
    
    
    func loadData() {
        let url = "\(fosunholidayHost)/poseidon/online/im/advisor/customers/\(advisorId)?pageNo=\(pageNo)&pageSize=10"
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
            if let data = res["data"] as? [String: Any], let customersD = data["data"] as? [Any] {
                let arr = TCIMCustomerModel.arrayWithData(arr: customersD)
                if self.pageNo == 1 {
                    self.dataSource.removeAll()
                }
                if arr.isEmpty {
                    self.pageNo-=1
                    self.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    return
                }
                self.dataSource.append(contentsOf: arr)
                self.tableView.reloadData()
            }
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.mj_header?.endRefreshing()
        } failure: { [unowned self] (error) in
            self.tableView.mj_footer?.endRefreshing()
            self.tableView.mj_header?.endRefreshing()
        }

        
    }
    
    /// 引导关注微信公众号资源位
    func loadNoticeViewData(complete: @escaping(() -> ())) {
        let url = fosunholidayHost+"/online/cms-api/pageComponent?code=TC_OrderList_Notice"
        TCNetworkManager.Instance.get(URLString: url, parameters: nil, success: { [weak self] (response) in
            guard let self = self  else {
                complete()
                return
            }
            if let res = response as? [String : Any], let data = res["data"] as? [String: Any],
               let pageComponent = data["pageComponent"] as? [String: Any] {
                if let componentContents = pageComponent["componentContents"] as? Array<[String: Any]>, !componentContents.isEmpty {
                    if let dic = componentContents.first {
                        self.addNoticeView(messages: ["开启微信通知，及时获取订单通知，了解更多玩法！点击前往~"])
                    }
                } else {
                    self.addNoticeView(messages: ["开启微信通知，及时获取订单通知，了解更多玩法！点击前往~", "撒大大加剧来看激烈的"])
//                    self.noticeView?.hiddenMessageTipView()
                }
            }
            complete()
        }, failure: {  [weak self] (error) in
            complete()
            guard let self = self else {return}
            self.noticeView?.hiddenMessageTipView()
        })
    }
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension TCIMCustomerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TCIMCustomerCell = tableView.dequeueReusableCell(withIdentifier: "TCIMCustomerCell") as! TCIMCustomerCell
        
        var model: TCIMCustomerModel = dataSource[indexPath.row]
        if indexPath.row < 4 {
            model.lastMessageTime = "21：02"
        }
        cell.configData(model: model)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TCIMUserCardViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
