//
//  TCCounterView.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/23.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

/// 计数器控件
class TCCounterView: UIView {

    var minusBtn: UIButton!
    var plusBtn: UIButton!
    var numL: UILabel!
    var defaultMin: Int = 1
    var defaultMax: Int = 10
    var currentNum: Int = -1 {
        didSet {
            self.updateBtnStatus()
            
        }
    }
    var counterViewChangedBlock: ((_ currentNum: Int) -> ())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let minusW: CGFloat = 25
        
        minusBtn = UIButton(type: .custom)
        minusBtn.setImage(UIImage.init(named: "hotel_minus_gray"), for: .normal)
        minusBtn.frame = CGRect(x: 0, y: 0, width: minusW, height: minusW)
        minusBtn.addTarget(self, action: #selector(minusBtnClick), for: .touchUpInside)
        minusBtn.isUserInteractionEnabled = false
        self.addSubview(minusBtn)
        
        plusBtn = UIButton(type: .custom)
        plusBtn.setImage(UIImage.init(named: "hotel_plus_hightlight"), for: .normal)
        plusBtn.frame = CGRect(x: self.bounds.width - minusW, y: 0, width: minusW, height: minusW)
        plusBtn.addTarget(self, action: #selector(plusBtnClick), for: .touchUpInside)
        self.addSubview(plusBtn)
        
        numL = UILabel()
        numL.frame = CGRect(x: minusBtn.frame.maxX, y: 0, width: self.bounds.width - minusW * 2, height: minusW)
        numL.text = "\(defaultMin)"
        numL.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        numL.textAlignment = .center
        numL.font = UIFont(name: "PingFangSC-Regular", size: 16)
        self.addSubview(numL)
        
    }
    
    @objc func minusBtnClick() {
        currentNum -= 1
    }
    
    @objc func plusBtnClick() {
        currentNum += 1
        
        
    }
    
    /// 刷新按钮状态/数值
    private func updateBtnStatus() {
        if currentNum <= defaultMin{
            minusBtn.isUserInteractionEnabled = false
            minusBtn.setImage(UIImage.init(named: "hotel_minus_gray"), for: .normal)
        } else {
            if !minusBtn.isUserInteractionEnabled {
                minusBtn.isUserInteractionEnabled = true
                minusBtn.setImage(UIImage.init(named: "hotel_minus_hightlight"), for: .normal)
            }
        }
        if currentNum >= defaultMax {
            plusBtn.isUserInteractionEnabled = false
            plusBtn.setImage(UIImage.init(named: "hotel_plus_gray"), for: .normal)
        } else {
            if !plusBtn.isUserInteractionEnabled {
                plusBtn.isUserInteractionEnabled = true
                plusBtn.setImage(UIImage.init(named: "hotel_plus_hightlight"), for: .normal)
            }
        }
        numL.text = "\(currentNum)"
        
        if self.counterViewChangedBlock != nil {
            counterViewChangedBlock!(currentNum)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
