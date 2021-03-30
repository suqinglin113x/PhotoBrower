//
//  TCIMUserCardViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/3/2.
//  Copyright © 2021 苏庆林. All rights reserved.
//  xxx的名片

import UIKit

private let isIphoneX = ((UIScreen.main.bounds.size.height >= 812) ? true : false)
class TCIMUserCardViewController: UIViewController {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var backButtonTopY: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var professionalTitleL: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var detailInfoView: UIView!
    @IBOutlet weak var detailInfoL: UILabel!
    @IBOutlet weak var messageIcon: UIImageView!
    @IBOutlet weak var bottomBackImageView: UIImageView!
    @IBOutlet weak var noticeView: TCPayResultNoticeView!
    
    var IM_memeberId: String = "tcuc_10086919"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var statusH: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusH = (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
        } else {
            statusH = UIApplication.shared.statusBarFrame.height
        }
        
        backButtonTopY.constant = statusH
        self.getUserInfoData()
        noticeView.messageTexts = ["开启微信通知，及时获取订单通知，了解更多玩法！点击前往~"]
    }

    func updateUIWithDate(res: [String: Any]) {
        let data = res["data"] as? [String: Any]
        
        let avatar = data?["avatarUrl"] as? String ?? ""
        userIcon.sd_setImage(with: URL(string: avatar), completed: nil)
        
        let username = data?["advisorName"] as? String
        userNameLabel.text = username
        
        let attach = NSTextAttachment()
        attach.bounds = CGRect(x: 5, y: -3, width: 40, height: 15)
        attach.image = UIImage.init(named: "IM_UserCard_authorize")
        let attri = NSMutableAttributedString(string: professionalTitleL.text!)
        attri.append(NSAttributedString(attachment: attach))
        professionalTitleL.attributedText = attri
        
        if let storeInfo = data?["storeInfos"] as? [[String: Any]] {
            let storeName = "时间锕卡卡的"//storeInfo[0]["name"] as? String ?? ""
            let address = "啥啥啥"//storeInfo[0]["address"] as? String ?? ""
            self.createEachHousingSourceView(name: storeName, address: address)
        }
    
        let intro = data?["intro"] as? String ?? ""
        if intro.isEmpty == true {
            detailInfoL.removeFromSuperview()
            messageIcon.removeFromSuperview()
            detailInfoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([detailInfoView.heightAnchor.constraint(lessThanOrEqualToConstant: 0)])
        } else {
            detailInfoL.text = intro
        }
        
        
        let backgroundUrl = data?["backgroundUrl"] as? String ?? ""
        bottomBackImageView.sd_setImage(with: URL(string: backgroundUrl), completed: nil)
    }

    func createEachHousingSourceView(name: String, address: String) {
       
        let view = UIView()
        stackView.addArrangedSubview(view)
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        let nameL = UILabel()
        
        view.addSubview(nameL)
        nameL.text = name
        nameL.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        nameL.font = UIFont(name: "PingFangSC-Semibold", size: 15)
        nameL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameL.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            nameL.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            nameL.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            nameL.heightAnchor.constraint(equalToConstant: 15)
        ])
        if name.count <= 0 {
            NSLayoutConstraint.activate([
                nameL.heightAnchor.constraint(equalToConstant: 0)
            ])
        }
        
        let addressL = UILabel()
        view.addSubview(addressL)
        addressL.text = name
        addressL.textColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        addressL.font = UIFont(name: "PingFangSC-Regular", size: 11)
        addressL.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressL.leftAnchor.constraint(equalTo: nameL.leftAnchor),
            addressL.topAnchor.constraint(equalTo: nameL.bottomAnchor, constant: 5),
            addressL.rightAnchor.constraint(equalTo: nameL.rightAnchor),
            addressL.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            addressL.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        ])
        let attach = NSTextAttachment()
        attach.bounds = CGRect(x: 0, y: -3, width: 15, height: 15)
        attach.image = UIImage.init(named: "local_item")
        let attri = NSMutableAttributedString(attachment: attach)
        attri.append(NSAttributedString(string: address))
        addressL.attributedText = attri
        if address.count <= 0 {
            NSLayoutConstraint.activate([
                addressL.heightAnchor.constraint(equalToConstant: 0)
            ])
        }
        
        self.view.layoutIfNeeded()
        // 白色 底部
        let lineV = UIView()
        stackView.addArrangedSubview(lineV)
        lineV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineV.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    
    func getUserInfoData() {
        let url = fosunholidayHost+"/poseidon/online/im/advisor/\(IM_memeberId)"
        TCNetworkManager.Instance.get(URLString: url, parameters: nil) { [unowned self](response) in
            if let res = response as? [String : Any] {
                if let hasError = res["hasError"] as? Bool, hasError{
                    guard let errorMessage = res["errorMessage"] as? String else {
                        return
                    }
                    GlobalUtils.Instance.showToastAddTo(self.view, title: errorMessage, duration: 1.5)
                    return
                }
                self.updateUIWithDate(res: res)
            }
        } failure: { (error) in
            
        }

    }

    @IBAction func backAction(_ sender: Any) {
        let vcArr = self.navigationController?.children

        if let arr = vcArr, arr[arr.count-2].isKind(of: TCIMCustomerViewController.self) {
            arr[arr.count-2].removeFromParent()
            self.navigationController?.popViewController(animated: true)
        } else {
            
        }
        
        
    }
}
