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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var professionalTitleL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    @IBOutlet weak var detailInfoL: UILabel!
    
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
        let attach = NSTextAttachment()
        attach.bounds = CGRect(x: 5, y: -3, width: 40, height: 20)
        attach.image = UIImage.init(named: "IM_UserCard_authorize")
        let attri = NSMutableAttributedString(string: "优雅的皮蛋喵")
        attri.append(NSAttributedString(attachment: attach))
        userNameLabel.attributedText = attri
        
        
        let attach2 = NSTextAttachment()
        attach2.bounds = CGRect(x: 0, y: -3, width: 15, height: 15)
        attach2.image = UIImage.init(named: "local_item")
        let attri2 = NSMutableAttributedString(attachment: attach2)
        attri2.append(NSAttributedString(string: "江苏省苏州市太仓市东仓南路是计算机上是的撒酒店都是"))
        addressL.attributedText = attri2
        
        
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        print(addressL.bounds)
        
        
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
