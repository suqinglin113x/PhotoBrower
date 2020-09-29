//
//  TCHotelSearchLocationView.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/27.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
private let kScalex: CGFloat = kScreenW/375.0

class TCHotelSearchLocationView: UIView {

    var bgView: UIView!
    
    var leftTableView: UITableView!
    var rightTableView: UITableView!
    var leftDataSource: [String] = []
    var rightDataSource: [[String]] = []
    var selectedLeftIndex: Int = 0
    var selectedRightIndex: Int = 0
    
    var selectedLocationCompleted: ((_ regionName: String, _ circleName: String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        
        
        self.createUI()
        
        self.getLoationData()
        
    }
    func createUI() {
        bgView = UIView()
        bgView.backgroundColor = .white
        bgView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: self.bounds.size.height - 100)
        self.addSubview(bgView)
        let closeBtn = UIButton(frame: CGRect(x: 0, y: bgView.frame.size.height, width: kScreenW, height: 100))
        closeBtn.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        self.addSubview(closeBtn)
        let resetButton = UIButton(type: .custom)
        resetButton.setTitle("重置", for: .normal)
        resetButton.layer.cornerRadius = 15
        resetButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.titleLabel?.font = UIFont(name: "PingFangSC-Medium", size: 13)
        resetButton.frame = CGRect(x: 15, y: bgView.bounds.size.height-10-30, width: 125 * kScalex, height: 30)
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
        
        let lineView = UIView(frame: CGRect(x: 0, y: resetButton.frame.origin.y-1-10, width: kScreenW, height: 1))
        lineView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        bgView.addSubview(lineView)
       
        leftTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 110, height: lineView.frame.origin.y), style: .plain)
        leftTableView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.separatorStyle = .none
        leftTableView.tableFooterView = UIView()
        bgView.addSubview(leftTableView)
        
        rightTableView = UITableView(frame: CGRect(x: leftTableView.frame.size.width, y: 0, width: kScreenW-leftTableView.bounds.size.width, height: leftTableView.bounds.size.height), style: .plain)
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.separatorStyle = .none
        rightTableView.tableFooterView = UIView()
        bgView.addSubview(rightTableView)
        
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: 网络
extension TCHotelSearchLocationView {
    func getLoationData() {
        for i in 0...20 {
            leftDataSource.append("闵行区\(i)")
            var tem: [String] = []
            for j in 0...20 {
                tem.append("报春路\(i)+\(j)")
            }
            rightDataSource.append(tem)
            
        }
        
        leftTableView.reloadData()
        rightTableView.reloadData()
        leftTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .bottom)
        self.tableView(leftTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
    }
}

// MARK: actions
extension TCHotelSearchLocationView {
    
    @objc func closeView() {
        UIView.animate(withDuration: 0.5) {
            self.bgView.frame.origin.y = -UIScreen.main.bounds.size.height
        } completion: { (com) in
            self.removeFromSuperview()
        }
    }
    
    @objc func resetChoosedLocation() {
        selectedLeftIndex = 0
        selectedRightIndex = 0
        leftTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
        leftTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        rightTableView.reloadData()
    }
    
    @objc func sureChoosedLocation() {
        debugPrint("确定")
        let regionName = leftDataSource[selectedLeftIndex]
        let circleName = rightDataSource[selectedLeftIndex][selectedRightIndex]
        debugPrint(regionName+circleName)
        if selectedLocationCompleted != nil {
            selectedLocationCompleted!(regionName, circleName)
        }
        UIView.animate(withDuration: 0.5) {
            self.bgView.frame.origin.y = -UIScreen.main.bounds.size.height
        } completion: { (com) in
            self.removeFromSuperview()
        }
    }
}


extension TCHotelSearchLocationView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return leftDataSource.count
        } else {
            return rightDataSource.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
        if tableView == leftTableView {
            
            cell?.textLabel?.text = leftDataSource[indexPath.row]
            
            if indexPath.row == selectedLeftIndex {
                cell?.textLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 12)
                let view = UIView(frame: CGRect(x: 0, y: 0, width: cell!.bounds.size.width, height: cell!.bounds.size.height))
                view.backgroundColor = .white
                cell?.selectedBackgroundView = view
            } else {
                cell?.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
            }
        } else {
            cell?.selectionStyle = .none
            cell?.imageView?.image = UIImage.init(named: "hotel_search_locationSele")
            let itemSize = CGSize(width: 15, height: 15);
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
            let imageRect = CGRect(x: 0.0, y: 0.0, width: itemSize.width, height: itemSize.height)
            cell?.imageView?.image?.draw(in: imageRect)
            cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext();
                  UIGraphicsEndImageContext();
            cell?.imageView?.isHidden = true
            cell?.textLabel?.text = rightDataSource[selectedLeftIndex][indexPath.row]
            if indexPath.row == selectedRightIndex {
                cell?.imageView?.isHidden = false
                cell?.textLabel?.font = UIFont(name: "PingFangSC-Semibold", size: 12)
            }
        }
        
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == leftTableView {
            return 42
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTableView {
            selectedLeftIndex = indexPath.row
            selectedRightIndex = 0
            leftTableView.reloadData()
            rightTableView.selectRow(at: IndexPath(row: 0, section: indexPath.section), animated: true, scrollPosition: .bottom)
            rightTableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section), at: .bottom, animated: true)
            rightTableView.reloadData()
        } else {
            selectedRightIndex = indexPath.row
            rightTableView.reloadData()
            
            
        }
    }
    
    
   
}


