//
//  TCHotelPeopleNumPickView.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/25.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelPeopleNumPickView: UIView {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var hotelNumL: UILabel!
    @IBOutlet weak var hotelNumMinusIV: UIImageView!
    @IBOutlet weak var hotelNumPlusIV: UIImageView!
    
    @IBOutlet weak var adultNumL: UILabel!
    @IBOutlet weak var adultNumMinusIV: UIImageView!
    @IBOutlet weak var adultNumPlusIV: UIImageView!
    
    @IBOutlet weak var childNumL: UILabel!
    @IBOutlet weak var chilsNumMinusIV: UIImageView!
    @IBOutlet weak var chilsNumPlusIV: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var hotelNum: Int = 1
    var adultNum: Int = 1
    var childNum: Int = 0
    
    var agesArr: [String] = []
    var agePickView: TCHotelGeneralPickerView!

    /// 选择入住人数完成
    var resultDict: [String: Any]? = [:]
    var peopleSelectedCompleted: ((_ resultDict: [String : Any]) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bgView.bounds
        maskLayer.path = UIBezierPath(roundedRect: self.bgView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        self.bgView.layer.mask = maskLayer
    }
    @IBAction func closeView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.bgView.frame.origin.y = UIScreen.main.bounds.size.height
        } completion: { (com) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func hotelNumMinusClick(_ sender: Any) {
        
        hotelNum -= 1
        if hotelNum == 1 {
            hotelNumMinusIV.image = UIImage.init(named: "hotel_minus_gray")
            hotelNumMinusIV.isUserInteractionEnabled = false
        }
        hotelNumPlusIV.isUserInteractionEnabled = true
        hotelNumPlusIV.image = UIImage.init(named: "hotel_plus_hightlight")
        hotelNumL.text = "\(hotelNum)"
    
    }
    @IBAction func hotelNumPlusClick(_ sender: Any) {
         
        hotelNum += 1
        if hotelNum == 8 {
            hotelNumPlusIV.image = UIImage.init(named: "hotel_plus_gray")
            hotelNumPlusIV.isUserInteractionEnabled = false
        }
        hotelNumMinusIV.isUserInteractionEnabled = true
        hotelNumMinusIV.image = UIImage.init(named: "hotel_minus_hightlight")
        hotelNumL.text = "\(hotelNum)"
    }
    
    @IBAction func adultNumMinusClick(_ sender: Any) {
        adultNum -= 1
        if adultNum == 1 {
            adultNumMinusIV.image = UIImage.init(named: "hotel_minus_gray")
            adultNumMinusIV.isUserInteractionEnabled = false
        }
        adultNumPlusIV.isUserInteractionEnabled = true
        adultNumPlusIV.image = UIImage.init(named: "hotel_plus_hightlight")
        adultNumL.text = "\(adultNum)"
    }
    @IBAction func adultNumPlusClick(_ sender: Any) {
        adultNum += 1
        if adultNum == 6 {
            adultNumPlusIV.image = UIImage.init(named: "hotel_plus_gray")
            adultNumPlusIV.isUserInteractionEnabled = false
        }
        adultNumMinusIV.isUserInteractionEnabled = true
        adultNumMinusIV.image = UIImage.init(named: "hotel_minus_hightlight")
        adultNumL.text = "\(adultNum)"
    }
    
    @IBAction func childNumMinusClick(_ sender: Any) {
        childNum -= 1
        if childNum == 0 {
            chilsNumMinusIV.image = UIImage.init(named: "hotel_minus_gray")
            chilsNumMinusIV.isUserInteractionEnabled = false
        }
        chilsNumPlusIV.isUserInteractionEnabled = true
        chilsNumPlusIV.image = UIImage.init(named: "hotel_plus_hightlight")
        childNumL.text = "\(childNum)"
//        tableView.reloadData()
        self.agesArr.remove(at: childNum)
        tableView.deleteRows(at: [IndexPath(row: childNum, section: 0)], with: .bottom)
    }
    @IBAction func childNumPlusClick(_ sender: Any) {
        childNum += 1
        if childNum == 6 {
            chilsNumPlusIV.image = UIImage.init(named: "hotel_plus_gray")
            chilsNumPlusIV.isUserInteractionEnabled = false
        }
        chilsNumMinusIV.isUserInteractionEnabled = true
        chilsNumMinusIV.image = UIImage.init(named: "hotel_minus_hightlight")
        childNumL.text = "\(childNum)"
        self.agesArr.append("请选择儿童年龄")
        tableView.insertRows(at: [IndexPath(row: childNum-1, section: 0)], with: .bottom)
    }
    
    @IBAction func sureButtonClick(_ sender: Any) {
        resultDict?["hotelNum"] = hotelNum
        resultDict?["adultNum"] = adultNum
        resultDict?["childNum"] = childNum
        resultDict?["childAges"] = agesArr
        if peopleSelectedCompleted != nil {
            peopleSelectedCompleted!(resultDict!)
        }
        UIView.animate(withDuration: 0.5) {
            self.bgView.frame.origin.y = UIScreen.main.bounds.size.height
        } completion: { (com) in
            self.removeFromSuperview()
        }

    }
    
}

extension TCHotelPeopleNumPickView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childNum
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        }
        cell?.selectionStyle = .none
        cell?.textLabel?.text = "儿童\(indexPath.row+1)"
        cell?.textLabel?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        cell?.textLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 14)
        cell?.detailTextLabel?.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        cell?.detailTextLabel?.text = agesArr[indexPath.row]
        cell?.detailTextLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        let arrow = UIImageView(image: UIImage.init(named: "hotel_right_arrow"))
        arrow.bounds = CGRect(x: 0, y: 0, width: 10, height: 10)
        cell?.accessoryView = arrow
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        agePickView = TCHotelGeneralPickerView(frame: self.bounds)
        var dataSource: [String] = []
        for i in 0...17 {
            dataSource.append("\(i)")
        }
        agePickView.dataSource = dataSource
        self.addSubview(agePickView)
        
        agePickView.chooseAgeComplete = { age in
            cell?.detailTextLabel?.text = age+"岁"
            cell?.detailTextLabel?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            self.agesArr.remove(at: indexPath.row)
            self.agesArr.insert(age, at: indexPath.row)
        }
        
    }
    
   
    
    
    @objc func hiddenAgePickView() {
        agePickView.removeFromSuperview()
    }
}
