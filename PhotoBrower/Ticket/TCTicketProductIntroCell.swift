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

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    func configData(data: (String, TCIntroItemContentModel)) {
        titleLabel.text = data.0
        var htmlStr = data.1.content ?? ""
        let headStr = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'><style>img{max-width:100%}</style></header>"
        htmlStr.insert(contentsOf: headStr, at: htmlStr.startIndex)
        wkWebView.loadHTMLString(htmlStr, baseURL: nil)
    }
    
}
