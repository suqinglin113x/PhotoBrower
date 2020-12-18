//
//  TCTicketProductIntroCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
import WebKit

class TCTicketProductIntroCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wkWebView: WKWebView!
    
    var refreshCellHeight: ((_ height: CGFloat) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wkWebView.navigationDelegate = self
        wkWebView.scrollView.isScrollEnabled = false
        wkWebView.scrollView.showsVerticalScrollIndicator = false
        
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    func configData(data: (String, TCIntroItemContentModel, iconStr: String)) {
        icon.image = UIImage.init(named: data.iconStr)
        titleLabel.text = data.0
        var temStr = data.1.content ?? ""
        if temStr.contains("<img") {
            temStr = temStr.replacingOccurrences(of: "src=\"", with: "src=\"https:")
        }
        let headStr = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style type=\"text/css\">img{max-width:100%}</style></header>"
        temStr.insert(contentsOf: headStr, at: temStr.startIndex)
        let htmlStr = "<div style=\"color:#666666;font-size:12px;font-family:PingFangSC-Regular\">\(temStr)</div>"
        
        wkWebView.loadHTMLString(htmlStr, baseURL: nil)
    }
    
}

extension TCTicketProductIntroCell: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.body.scrollHeight;") { (result, error) in
            guard let h = result as? CGFloat else {
                return
            }
            self.wkWebView.frame.size.height = h
//            print("高度\(h)")
            if self.refreshCellHeight != nil {
                self.refreshCellHeight!(h)
            }
        }
        
    }
    
    
}
