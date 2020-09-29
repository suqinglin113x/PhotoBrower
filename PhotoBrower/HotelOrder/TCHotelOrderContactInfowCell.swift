//
//  TCHotelOrderContactInfowCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/27.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelOrderContactInfowCell: UITableViewCell {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userPhoneTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    
    @IBOutlet weak var bedView: UIView!
    @IBOutlet weak var bedTypeLabel: UILabel!
    @IBOutlet weak var remarkView: UIView!
    @IBOutlet weak var remarkLabel: UILabel!
    var selectedMarks: [String]? = []
    /// 备注选完了
    var selectedRemarkCompleted: ((_ marks: [String]) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(chooseBedType))
        bedView.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(chooseRemark))
        remarkView.addGestureRecognizer(tap2)
    }
    
    @objc func chooseBedType() {
        let agePickView = TCHotelGeneralPickerView(frame: UIScreen.main.bounds)
        let dataSource: [String] = ["大床", "小床", "中床", "单人床", "双人床"]
        agePickView.dataSource = dataSource
        UIApplication.shared.windows[0].addSubview(agePickView)
        
        agePickView.chooseAgeComplete = { bedType in
            self.bedTypeLabel.text = bedType
        }
    }
    
    @objc func chooseRemark() {
        
        let view = RemarkView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        view.createButtonsView(withSele: selectedMarks ?? [])
        view.selectedMarkCompleted = { arr in
            debugPrint(arr)
            if arr.isEmpty {
                self.remarkLabel.text = "查看可选备注"
            } else {
                self.remarkLabel.text = "查看已选备注(\(arr.count))"
            }

            self.selectedMarks = arr
            if self.selectedRemarkCompleted != nil {
                self.selectedRemarkCompleted!(arr)
            }
        }
        UIApplication.shared.windows[0].addSubview(view)
    }
    
    
    
}
/********************分水岭**********************/


/********************分水岭**********************/
private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
private let kScalex: CGFloat = kScreenW/375.0
class RemarkView: UIView {
    
    var closeButton: UIButton!
    var bgView: UIView!
    
    var selectedMarks: [(title: String, isSelected: Bool)] = []
    var selectedMarkCompleted: ((_ marks: [String]) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.createRemarkView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 选择备注
    private func createRemarkView() {
        let bgViewH: CGFloat = 344
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        closeButton = UIButton(frame: CGRect(x: kScreenW-35, y: kScreenH-bgViewH-35, width: 35, height: 35))
        closeButton.setImage(UIImage.init(named: "hotel_order_close_white"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeRemarkView), for: .touchUpInside)
        self.addSubview(closeButton)
        
        bgView = UIView(frame: CGRect(x: 0, y: kScreenH - 344, width: kScreenW, height: bgViewH))
        bgView.backgroundColor = .white
        self.addSubview(bgView)
        let path = UIBezierPath(roundedRect: bgView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bgView.bounds
        maskLayer.path = path.cgPath
        bgView.layer.mask = maskLayer
        
        let titleL = UILabel(frame: CGRect(x: 15, y: 25, width: UIScreen.main.bounds.size.width - 30, height: 16))
        titleL.text = "选择备注"
        titleL.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 16)
        bgView.addSubview(titleL)
        
        self.createButtonsView(withSele: [])
        
        let tipLabel = UILabel(frame: CGRect(x: 15, y: 205, width: kScreenW - 30, height: 40))
        tipLabel.text = "当前仅支持以上备注选项。酒店会尽量协调，无法承诺一定实现，部分要求可能会产生额外费用。"
        tipLabel.numberOfLines = 2
        tipLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        tipLabel.font = UIFont(name: "PingFangSC-Regular", size: 11)
        bgView.addSubview(tipLabel)
        
        let line = UIView(frame: CGRect(x: 15, y: 261, width: kScreenW-30, height: 1))
        line.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1)
        bgView.addSubview(line)
        
        let resetButton = UIButton(type: .custom)
        resetButton.setTitle("取消", for: .normal)
        resetButton.layer.cornerRadius = 15
        resetButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 13)
        resetButton.frame = CGRect(x: 15, y: bgViewH-43-30, width: 125 * kScalex, height: 30)
        resetButton.addTarget(self, action: #selector(resetChoosedLocation), for: .touchUpInside)
        bgView.addSubview(resetButton)
        
        let sureButton = UIButton(type: .custom)
        sureButton.setTitle("确定", for: .normal)
        sureButton.layer.cornerRadius = 15
        sureButton.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
        sureButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        sureButton.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 13)
        sureButton.frame = CGRect(x: kScreenW - 15 - 210*kScalex, y: resetButton.frame.origin.y, width: 210*kScalex, height: 30)
        sureButton.addTarget(self, action: #selector(sureChoosedLocation), for: .touchUpInside)
        bgView.addSubview(sureButton)
        
       
    }
    
    /// 中间的备注选项部分 (已选中的要高亮)
    func createButtonsView(withSele seleButtons: [String]) {
        let remarkArr = ["低楼层", "靠近电梯", "远离电梯", "延迟退房", "豪华双人浴缸", "隔音好", "加儿童床", "国际电视节目及网络", "提早入住"]
        var buttomArray: [UIButton] = []
        for title in remarkArr {
            let height: CGFloat = 35.0
            let width = (title as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont(name: "PingFangSC-regular", size: 12)!], context: nil).size.width + 30
            let margin: CGFloat = 10
            let lastBtn = buttomArray.last
            let nextBtn = self.createButton(title: title)
            var x: CGFloat = (lastBtn?.frame.origin.x ?? 15) + (lastBtn?.bounds.size.width ?? 0)+((lastBtn != nil) ? margin : 0)
            var y: CGFloat = lastBtn?.frame.origin.y ?? (61)
            if (x + width) > (bgView.bounds.size.width - 15) {
                y = y + height + margin
                x = 15
            }
            
            nextBtn.frame = CGRect(x: x, y: y, width: width, height: height)
            buttomArray.append(nextBtn)
            bgView.addSubview(nextBtn)
            // 如果初始就有选中的
            if seleButtons.contains(title) {
                self.clickButton(button: nextBtn)
            }
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
        button.layer.cornerRadius = 2.5
        return button
    }
    
    @objc func clickButton(button: UIButton) {
        
        let btnTitle: String = (button.titleLabel?.text)!
        
        button.isSelected = !button.isSelected
        if button.isSelected {
            selectedMarks.append((btnTitle, true))
            button.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0, alpha: 1)
            button.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        } else {
            let index = selectedMarks.firstIndex { (title, isSele) -> Bool in
                return btnTitle == title
            }
            selectedMarks[index ?? 0].isSelected = false
            button.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
            button.setTitleColor(UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), for: .normal)
        }
    }
    
    @objc func closeRemarkView() {
        UIView.animate(withDuration: 0.5) {
            self.closeButton.frame.origin.y = kScreenH
            self.bgView.frame.origin.y = kScreenH
        } completion: { (com) in
            self.removeFromSuperview()
        }
    }
    
    @objc func resetChoosedLocation() {
        closeRemarkView()
    }
    
    @objc func sureChoosedLocation() {
        debugPrint("点击确定")
        self.closeRemarkView()
        if selectedMarkCompleted != nil {
            if selectedMarks.isEmpty {
                return
            }
            var temArr: [String] = []
            selectedMarks.forEach { (title, isSele) in
                if isSele {
                    temArr.append(title)
                }
            }
            selectedMarkCompleted!(temArr)
        }
        
    }
    
}

