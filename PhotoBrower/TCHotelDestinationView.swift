//
//  TCHotelDestinationView.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/24.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

private let kScreenW: CGFloat = UIScreen.main.bounds.size.width

class TCHotelDestinationView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var inlandButton: UIButton!
    @IBOutlet weak var outlandButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var sectionTitles: [String] = []
    var tabHeaderView: TCHotelDestinationHeader!
    
   
    override func awakeFromNib() {
//        super.awakeFromNib()
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bgView.bounds
        maskLayer.path = UIBezierPath.init(roundedRect: self.bgView.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        self.bgView.layer.mask = maskLayer
        tableView.sectionIndexColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        tableView.sectionIndexBackgroundColor = .white
        tabHeaderView = (Bundle.main.loadNibNamed("TCHotelDestinationHeader", owner: nil, options: nil)?.first as! TCHotelDestinationHeader)
        tableView.tableHeaderView = tabHeaderView
        self.getData()
        self.getCityList()
    }
   
    
    
    func getData() {
        sectionTitles = ["A", "B", "C", "D", "E","F", "G", "H"]
        
        tabHeaderView.configHistoryData(data: ["香格里拉", "成都", "重庆", "哈尔滨", "千岛湖"])
        tabHeaderView.configHotData(data: ["香格里拉", "成都", "重庆", "哈尔滨", "千岛湖", "成都", "重庆", "哈尔滨", "千岛湖"])
        tableView.reloadData()
    }
    
    func getCityList() {
        
    }
    
    @IBAction func closeIt(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}

extension TCHotelDestinationView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.font = UIFont(name: "PingFangSC-Regular", size: 13)
            cell?.textLabel?.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        cell?.textLabel?.text = "上海浦东"
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("dssss ")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        let label = UILabel()
        label.text = sectionTitles[section]
        label.font = UIFont(name: "PingFangSC-Medium", size: 13)
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.frame = CGRect(x: 15, y: 0, width: 50, height: 20)
        view.addSubview(label)
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
}
