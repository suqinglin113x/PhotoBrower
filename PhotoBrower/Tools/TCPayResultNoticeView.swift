//
//  TCPayResultNoticeView.swift
//  ThomasCook
//
//  Created by 苏庆林 on 2021/3/23.
//  Copyright © 2021 Mars Zhang. All rights reserved.
//

import UIKit

class TCPayResultNoticeView: UIView {
    var closeActionClicked:(() -> ())?
    private var messageTipView: UIView!
    private var messageTipLabel: UILabel!
    private let messageTipViewH: CGFloat = 25
    private var messageText: String = ""
    init(frame: CGRect, message: String) {
        super.init(frame: frame)
        messageText = message
        self.createMessageTipView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let labe = UILabel(frame: CGRect(x: 20, y: 0, width: btn.frame.minX-20, height: messageTipView.bounds.height))
        labe.textColor = #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1)
        labe.font = UIFont(name: "PingFangSC-Regular", size: 11)
        let tx: NSString = messageText as NSString
        let att = NSMutableAttributedString(string: tx as String)
        let range = tx.range(of: "点击前往~")
        att.addAttributes([NSAttributedString.Key.font: UIFont(name: "PingFangSC-Semibold", size: 11) as Any], range: NSRange(location: range.location, length: range.length))
        labe.attributedText = att
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toweixinBizProfilePage))
        labe.addGestureRecognizer(tap)
        labe.isUserInteractionEnabled = true
        messageTipView.addSubview(labe)
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
    func hiddenMessageTipView () {
        messageTipView.isHidden = true
        messageTipView.subviews.forEach({$0.removeFromSuperview()})
        messageTipView.removeFromSuperview()
    }
}
