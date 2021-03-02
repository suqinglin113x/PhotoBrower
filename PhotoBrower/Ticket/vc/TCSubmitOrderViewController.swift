//
//  TCSubmitOrderViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/22.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit


private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
private let isIphoneX = (kScreenH >= 812)

/// 订单来源类型
enum OrderSourceType: String {
    case ticket = "门票"
    case presale = "预售"
    case travel = "自由行"
    case unkonwn
}

class TCSubmitOrderViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var orderPriceL: UILabel!
    @IBOutlet weak var submitViewConstraintH: NSLayoutConstraint!
    var orderSourceType: OrderSourceType = .unkonwn
    /// title:左边UI subTitle:右边UI
    var dataSource: [(title: String, subTitle: String)] = []
    var identity: TravelTripInfoCellIdentity = .one
    var travellerNum: Int = 0
/* -----------*/
    var contactName: String = ""
    var contactPhone: String = ""
    /// 用户备注
    var contactRemark: String = ""
    var passengerDTOs: String = ""
    
/* -----------*/
    /// 标题
    var navTitle: String = ""
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
    
    lazy var tableView: UITableView = {
        
        let topY: CGFloat = isIphoneX ? statusH + 44 : statusH + 44
        let tab = UITableView(frame: .zero, style: .plain)
        tab.frame = CGRect(x: 0.0, y: topY, width: kScreenW, height: kScreenH - topY - submitViewConstraintH.constant)
        tab.backgroundColor = .clear
        tab.showsVerticalScrollIndicator = false
        tab.delegate = self
        tab.dataSource = self
        tab.separatorStyle = .none
        tab.register(TCSubmitTitleCell.self, forCellReuseIdentifier: "TCSubmitTitleCell")
        tab.register(TCSubmitOrderInfosCell.self, forCellReuseIdentifier: "TCSubmitOrderInfosCell")
        tab.register(TCSubmitContactCell.self, forCellReuseIdentifier: "TCSubmitContactCell")
        tab.register(UINib.init(nibName: "TCSubmitContactCell", bundle: nil), forCellReuseIdentifier: "TCSubmitContactCell")
        tab.register(UINib.init(nibName: "TCSubmitTicketRealNameCell", bundle: nil), forCellReuseIdentifier: "TCSubmitTicketRealNameCell")

        tab.register(UINib.init(nibName: "TCSubmitDiscountCell", bundle: nil), forCellReuseIdentifier: "TCSubmitDiscountCell")
        
        return tab
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if !isIphoneX {
            submitViewConstraintH.constant = 60
        }
        self.navTitle = "Club Med畅享阿尔卑斯雪季30天29晚度假+ESF专业滑雪课程"
        self.view.addSubview(customNavHeader)
        
        self.view.addSubview(self.tableView)
        
        
        switch orderSourceType {
        case .presale:
            dataSource = [("Palm Manor特大号床间任选 + 含早2晚", ""), ("国庆/中秋/春节等法定假日不可使用，需提前至少30天预约，购买前…", ""), ("￥999999", "a")]
        case .ticket:
            dataSource = [("使用日期", "2020/12/01"), ("购买数量", "1"), ("取票方式", "电子票")]
        case .travel:
            dataSource = [("出行日期", "2020/12/01"), ("目的地", "普罗旺斯"), ("出行人", "2成人 2儿童"), ("购买数量", "4")]
            
        case .unkonwn:
            break
        }
    }


    

}

extension TCSubmitOrderViewController {
    
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showPriceDetail(_ sender: Any) {
        debugPrint("点了明细")
    }
    
    @IBAction func submitOrderWithInfo(_ sender: Any) {
        debugPrint("点了提交")
        
    }
}


extension TCSubmitOrderViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            if orderSourceType == .presale {
                return 0
            }
            if orderSourceType == .ticket {
                return 2
            }
            if orderSourceType == .travel {
                if identity == .one {
                    return 1
                } else {
                    return travellerNum
                }
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 { // 标题
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCSubmitTitleCell") as! TCSubmitTitleCell
            cell.title = navTitle
            return cell
        } else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCSubmitOrderInfosCell") as! TCSubmitOrderInfosCell
            
            if orderSourceType == .ticket {
                
                cell.configData(items: dataSource, type: orderSourceType, orderName: "单日-家庭套票")
            } else if orderSourceType == .travel {
                
                cell.configData(items: dataSource, type: orderSourceType)
            } else if orderSourceType == .presale { // 预售
                cell.configPresaleData(data: dataSource)
                cell.presaleNumChanged = { [weak self] num in
                    guard let self = self else {
                        return
                    }
                    var last  = self.dataSource.last
                    last?.subTitle = "\(num)"
                    print(last as Any)
                    self.dataSource.removeLast()
                    self.dataSource.append(last!)
                }
            }
            
            return cell
            
        } else if indexPath.section == 2 { // 联系人
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCSubmitContactCell") as! TCSubmitContactCell
            cell.textFieldEndEdit = {
                self.contactName = cell.contactNameTF.text ?? ""
                self.contactPhone = cell.contactPhoneTF.text ?? ""
                self.contactRemark = cell.markTV.text ?? ""
            }
            return cell
        } else if indexPath.section == 3 { // 实名制or出行人or预售空缺
            if orderSourceType == .ticket {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TCSubmitTicketRealNameCell") as! TCSubmitTicketRealNameCell
                
                return cell
            }
            if orderSourceType == .travel {
                
                let cell = TCSubmitTravelTripInfoCell.cellForIdentity(tableView: tableView, identity: identity)

                return cell
            }
            return UITableViewCell()
            
        } else { // 优惠
            let cell = tableView.dequeueReusableCell(withIdentifier: "TCSubmitDiscountCell") as! TCSubmitDiscountCell
            cell.configData(orderType: orderSourceType)
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { // 标题part
            let h = (navTitle as NSString).boundingRect(with: CGSize(width: kScreenW-30, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont(name: "PingFangSC-Semibold", size: 18) as Any], context: nil).size.height
            
            return 40 + h
        } else if (indexPath.section == 1) { // 订单信息part
            if orderSourceType == .presale {
                return 115
            }
            return 127
        } else if indexPath.section == 2 { // 联系人part
            return 210
        } else if indexPath.section == 3 { // 实名制or出行人or预售空缺part
            if orderSourceType == .ticket {
                return 97
            }
            if orderSourceType == .presale {
                return 0
            }
            if orderSourceType == .travel {
                if identity == .one {
                    return 53
                } else {
                    return 142
                }
            }
        } else { // 优惠part
            if orderSourceType == .presale {
                return 210
            } else {
                return 260
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 && orderSourceType == .travel {
            let listVC = TCTravellerListViewController()
            self.navigationController?.pushViewController(listVC, animated: true)
            listVC.chooseTravellerCompleted = { travellerNum in
                self.identity = .two
                self.travellerNum = travellerNum
                self.tableView.reloadSections([indexPath.section], with: .automatic)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3 && orderSourceType != .presale { // 实名制or出行人or预售空缺part
            return 54
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 && orderSourceType != .presale {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 54))
            view.backgroundColor = .white
            let label = UILabel(frame: CGRect(x: 15, y: 10, width: UIScreen.main.bounds.size.width-30, height: view.bounds.size.height-10))
            label.text = "实名制（请如实填写）"
            label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            label.font = UIFont(name: "PingFangSC-Semibold", size: 14)
            view.addSubview(label)
            return view
        }
        return nil
    }
    
    
}


extension TCSubmitOrderViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
