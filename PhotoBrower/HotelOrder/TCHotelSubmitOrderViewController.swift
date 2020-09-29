//
//  TCHotelSubmitOrderViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/22.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit


private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
private let isIphoneX = (kScreenH >= 812)

class TCHotelSubmitOrderViewController: UIViewController {

    @IBOutlet weak var submitOrderViewH: NSLayoutConstraint!
    @IBOutlet weak var orderPriceL: UILabel!
    
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
    
    var backButton: UIButton!
    var titleL: UILabel!
    lazy var customNavHeader: UIView = {
        
        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: kScreenW, height: isIphoneX ? statusH + 44 : statusH + 44)
        
        backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: statusH, width: 44, height: 44)
        backButton.setImage(UIImage.init(named: "back_white"), for: .normal)
        backButton.addTarget(self,action:#selector(closeVC),for:.touchUpInside)
        navHeader.addSubview(backButton)
        
        titleL = UILabel()
        titleL.frame = CGRect(x: 0, y: backButton.frame.origin.y, width: kScreenW - 44*2, height: 44)
        titleL.center = CGPoint(x: kScreenW * 0.5, y: backButton.center.y)
        titleL.text = self.navTitle
        titleL.textColor = .white
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        navHeader.addSubview(titleL)
        
        return navHeader
    }()
    lazy var bgView: UIView = {
        let topY: CGFloat = isIphoneX ? statusH + 44 : statusH + 44
        let bgView = UIView()
        bgView.frame = CGRect(x: 0.0, y: topY, width: kScreenW, height: kScreenH - topY - submitOrderViewH.constant)
        let path = UIBezierPath(roundedRect: bgView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bgView.bounds
        maskLayer.path = path.cgPath
        bgView.layer.mask = maskLayer
        return bgView
    }()
    
    lazy var tableView: UITableView = {
        
        let topY: CGFloat = isIphoneX ? statusH + 44 : statusH + 44
        let tab = UITableView(frame: .zero, style: .plain)
        tab.frame = CGRect(x: 0.0, y: topY, width: kScreenW, height: kScreenH - topY - submitOrderViewH.constant)
        tab.backgroundColor = .clear
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.register(UINib.init(nibName: "TCHotelOrderHotelInfowCell", bundle: Bundle.main), forCellReuseIdentifier: "TCHotelOrderHotelInfowCell")
        tab.register(UINib.init(nibName: "TCHotelOrderContactInfowCell", bundle: nil), forCellReuseIdentifier: "TCHotelOrderContactInfowCell")
        tab.register(UINib.init(nibName: "TCHotelOrderTripInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "TCHotelOrderTripInfoCell")
        tab.register(UINib.init(nibName: "TCHotelOrderPayTypeCell", bundle: Bundle.main), forCellReuseIdentifier: "TCHotelOrderPayTypeCell")
        return tab
    }()
    /// 选择了几间房
    var roomNum: Int?
    /// 订房总人数
    var allPeopleNum: Int? = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        if !isIphoneX {
            submitOrderViewH.constant = 70
        }
        self.view.addSubview(customNavHeader)
        self.view.addSubview(tableView)
        
    }
   

    
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func showPriceDetail(_ sender: Any) {
        debugPrint("价格明细")
        let view = TCHotelPriceDetailView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
        self.view.addSubview(view)
    }
    
    @IBAction func submitOrderWithInfo(_ sender: Any) {
        debugPrint("提交订单")
    }
}


extension TCHotelSubmitOrderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 { // 出行人信息
            return allPeopleNum ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // 房间套餐信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCHotelOrderHotelInfowCell") as! TCHotelOrderHotelInfowCell
            
            return cell
        }
        if indexPath.section == 1 { // 联系人信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCHotelOrderContactInfowCell") as! TCHotelOrderContactInfowCell
            return cell
        }
        if indexPath.section == 2 { // 出行人信息
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCHotelOrderTripInfoCell") as! TCHotelOrderTripInfoCell
            return cell
        }
        if indexPath.section == 3 { // 支付方式
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCHotelOrderPayTypeCell") as! TCHotelOrderPayTypeCell
            cell.choosePayTypeComplete = { payType in
                if payType == .weixinPay {
                    debugPrint("我是微信支付")
                }
                if payType == .aliPay {
                    debugPrint("我是支付宝支付")
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }
        if indexPath.section == 1 {
            return 297
        }
        if indexPath.section == 2 {
            return 132
        }
        return 230
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 { // 出行人信息
            return 54
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 54))
            view.backgroundColor = .white
            let label = UILabel(frame: CGRect(x: 15, y: 10, width: UIScreen.main.bounds.size.width-30, height: view.bounds.size.height-10))
            label.text = "出行人信息"
            label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            label.font = UIFont(name: "PingFangSC-Semibold", size: 14)
            view.addSubview(label)
            return view
        }
        return nil
    }
    
    
}


extension TCHotelSubmitOrderViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
        
        let offY = scrollView.contentOffset.y
        let alpha = (64 - offY)/64
        if alpha < 0.3 {
            customNavHeader.backgroundColor = .white
            customNavHeader.alpha = 1
            backButton.setImage(UIImage.init(named: "back_black"), for: .normal)
            titleL.textColor = .black
        } else {
            customNavHeader.backgroundColor = .clear
            customNavHeader.alpha = alpha
            backButton.setImage(UIImage.init(named: "back_white"), for: .normal)
            titleL.textColor = .white
        }
        
    }
}
