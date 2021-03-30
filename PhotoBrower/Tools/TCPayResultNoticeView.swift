//
//  TCPayResultNoticeView.swift
//  ThomasCook
//
//  Created by 苏庆林 on 2021/3/23.
//  Copyright © 2021 Mars Zhang. All rights reserved.
//

import UIKit

class TCPayResultNoticeView: UIView, AdvertScrollViewDelegate {
    
    var closeActionClicked:(() -> ())?
    private var messageTipView: UIView!
//    private var messageTipLabel: UILabel!
    private let messageTipViewH: CGFloat = 25
    private var adver: AdvertScrollView!
    @objc var messageTexts: [String] = [] {
        didSet {
//            if let la = messageTipLabel {
//                la.text = messageText
//            }
            if let ad = adver {
                ad.titles = messageTexts
            }
        }
    }
    @objc var textLeftMargin: CGFloat = 5
    init(frame: CGRect, messages: [String]) {
        super.init(frame: frame)
        messageTexts = messages
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        if messageTipView == nil {
            createMessageTipView()
        }
    }
    func createMessageTipView() {
        messageTipView = UIView(frame: self.bounds)
        messageTipView.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0.8862745098, alpha: 1)
        self.addSubview(messageTipView)
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage.init(named: "orange_close"), for: .normal)
        btn.frame = CGRect(x: messageTipView.bounds.width-6-16, y: 0, width: 16, height: 16)
        btn.center.y = messageTipView.bounds.height/2.0
        btn.addTarget(self, action: #selector(closeMessageTipView), for: .touchUpInside)
        messageTipView.addSubview(btn)
        
//        messageTipLabel = UILabel(frame: CGRect(x: textLeftMargin, y: 0, width: btn.frame.minX-20, height: messageTipView.bounds.height))
//        messageTipLabel.textColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1)
//        messageTipLabel.font = UIFont(name: "PingFangSC-Regular", size: 11)
//        let tx: NSString = messageText as NSString
//        let att = NSMutableAttributedString(string: tx as String)
//        let range = tx.range(of: "点击前往~")
//        att.addAttributes([NSAttributedString.Key.font: UIFont(name: "PingFangSC-Semibold", size: 11) as Any], range: NSRange(location: range.location, length: range.length))
//        messageTipLabel.attributedText = att
//        let tap = UITapGestureRecognizer(target: self, action: #selector(toweixinBizProfilePage))
//        messageTipLabel.addGestureRecognizer(tap)
//        messageTipLabel.isUserInteractionEnabled = true
//        messageTipView.addSubview(messageTipLabel)
        
        adver = AdvertScrollView(frame: CGRect(x: textLeftMargin, y: 0, width: btn.frame.minX-20, height: messageTipView.bounds.height))
        adver.delegate = self
        adver.titles = messageTexts
        adver.titleFont = UIFont(name: "PingFangSC-Regular", size: 11)
        adver.titleColor = #colorLiteral(red: 1, green: 0.4863265157, blue: 0, alpha: 1)
        adver.backgroundColor = .clear
        messageTipView.addSubview(adver)
        
    }
    
    
    @objc func toweixinBizProfilePage() {
        print("打开微信")
    }
    @objc func closeMessageTipView() {
        self.hiddenMessageTipView()
        if (self.closeActionClicked != nil) {
            self.closeActionClicked!()
        }
        UserDefaults.standard.set(true, forKey: "userManualClose")
        UserDefaults.standard.synchronize()
    }
    @objc func hiddenMessageTipView () {
        self.isHidden = true
    }
    
    
    func advertScrollView(advertScrollView: AdvertScrollView, index: NSInteger) {
        print(index)
    }
    
}
