//
//  TCHotelDestinationController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/24.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
class TCHotelDestinationController: UIViewController {

    @IBOutlet weak var topBgImageView: UIImageView!
    @IBOutlet weak var heaerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 125)
        self.view.backgroundColor = .gray
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bgView.bounds
        maskLayer.path = UIBezierPath.init(roundedRect: bgView.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 15, height: 15)).cgPath
        self.bgView.layer.mask = maskLayer
        
        let tabHeaderView = UIView()
        tableView.backgroundColor = .red
        tableView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: 377)
        tableView.tableHeaderView = tabHeaderView
        
    }


    

}


extension TCHotelDestinationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "上海浦东"
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
