//
//  TCHotelDestinationHeader.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/24.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
class TCHotelDestinationHeader: UIView {

    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var historyButtonView: UIView!
    @IBOutlet weak var hotView: UIView!
    @IBOutlet weak var hotButtonView: UIView!
    
    var historyButtonArray: [UIButton] = []
    var hotButtomArray: [UIButton] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    
    func configHistoryData(data: [String]) {
        // 创建第一个
        
        for (index, title) in data.enumerated() {
            let height: CGFloat = 35.0
            let width = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-regular", size: 12)!], context: nil).size.width + 20
            
            let lastBtn = historyButtonArray.last
            let nextBtn = self.createButton(title: title)
            let x: CGFloat = (lastBtn?.frame.origin.x ?? 0) + (lastBtn?.bounds.size.width ?? 0)+((lastBtn != nil) ? 7.5 : 0)
            if (x + width) > (hotButtonView.bounds.size.width - 23) {
                return
            }
            nextBtn.frame = CGRect(x: x, y: 0, width: width, height: height)
            historyButtonArray.append(nextBtn)
            historyButtonView.addSubview(nextBtn)
            
        }
    }
    
    func configHotData(data: [String]) {
        // 创建第一个
        
        for title in data {
            let height: CGFloat = 35.0
            let width = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-regular", size: 12)!], context: nil).size.width + 20
            
            let lastBtn = hotButtomArray.last
            let nextBtn = self.createButton(title: title)
            var x: CGFloat = (lastBtn?.frame.origin.x ?? 0) + (lastBtn?.bounds.size.width ?? 0)+((lastBtn != nil) ? 7.5 : 0)
            var y: CGFloat = lastBtn?.frame.origin.y ?? 0
            if (x + width) > (hotButtonView.bounds.size.width - 23) {
                y = height + 7.5
                x = 0
            }
            
            nextBtn.frame = CGRect(x: x, y: y, width: width, height: height)
            hotButtomArray.append(nextBtn)
            hotButtonView.addSubview(nextBtn)
            
        }
    }
    
    func createButton(title: String) -> UIButton {
        let font = UIFont(name: "PingFangSC-regular", size: 12)
        
        let button = UIButton(type: .custom)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        return button
    }
    
    
    @objc func clickButton(button: UIButton) {
        debugPrint(button.titleLabel?.text)
        
    }
}
