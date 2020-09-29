//
//  TCHotelGeneralPickerView.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/27.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCHotelGeneralPickerView: UIView {
    /// 选择poi类型结束
    var chooseAgeComplete: ((_ age: String) -> ())?
    var poiIdArray: [String] = []
    /// 选中的component， 默认0
    var selectedComponent: Int = 0
    private var _dataSource: [String] = []
    /// 传给我值就行
    var dataSource: [String] {
        get {
            return _dataSource
        }
        set {
            _dataSource = newValue
            self.pickerView.reloadAllComponents()
        }
    }
    
    
    private lazy var pickerView: UIPickerView = {
        let pickerView  = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    lazy var pickLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "PingFangSC-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
  
    
    private lazy var pickerHeader: UIView = {
        let view  = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 44)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        let cancelButton = UIButton.init()
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        cancelButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        cancelButton.addTarget(self,action:#selector(hiddenPickView),for:.touchUpInside)
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(-3)
            make.left.equalTo(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        let sureButton = UIButton.init()
        sureButton.setTitle("确定", for: .normal)
        sureButton.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        sureButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        sureButton.addTarget(self,action:#selector(savePickView),for:.touchUpInside)
        view.addSubview(sureButton)
        sureButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(-3)
            make.right.equalTo(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        view.addSubview(pickLabel)
        pickLabel.text = ""
        pickLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.bottom.equalTo(-3)
            make.height.equalTo(40)
        }
        
        let line  = UIView()
        line.backgroundColor = UIColor(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1)
        view.addSubview(line)
        line.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let sureButton = UIButton.init()
        sureButton.addTarget(self,action:#selector(hiddenPickView),for:.touchUpInside)
        sureButton.frame = self.bounds
        self.addSubview(sureButton)
        self.addSubview(self.pickerView)
        self.pickerView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(350)
        }
        pickerView.selectRow(0, inComponent: 0, animated: true)
        
        self.addSubview(pickerHeader)
        self.pickerHeader.snp.makeConstraints { (make) in
            make.bottom.equalTo(pickerView.snp_topMargin).offset(10)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(44)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func hiddenPickView () {
        self.removeFromSuperview()
    }
    
    @objc func savePickView () {
        
        if (self.chooseAgeComplete != nil) {
            self.chooseAgeComplete!(dataSource[selectedComponent])
        }
        
        self.removeFromSuperview()
    }
}



extension TCHotelGeneralPickerView:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        debugPrint("点了\(dataSource[row])")
        selectedComponent = row
    }
    
    
}
