//
//  ViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
private let kScreenW: CGFloat = UIScreen.main.bounds.size.width
private let kScreenH: CGFloat = UIScreen.main.bounds.size.height
class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        
        
        let button1 = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 30))
        button1.setTitle("相册", for: .normal)
        button1.setTitleColor(.black, for: .normal)
        button1.addTarget(self, action: #selector(toPhotosList), for: .touchUpInside)
        self.view.addSubview(button1)
        
        
        let button2 = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 30))
        button2.setTitle("评论", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.addTarget(self, action: #selector(toCommentList), for: .touchUpInside)
        self.view.addSubview(button2)
        
        let button3 = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 30))
        button3.setTitle("订单页", for: .normal)
        button3.setTitleColor(.black, for: .normal)
        button3.addTarget(self, action: #selector(toOrderPage), for: .touchUpInside)
        self.view.addSubview(button3)
        
        let button4 = UIButton(frame: CGRect(x: 200, y: 200, width: 100, height: 30))
        button4.setTitle("选择目的地", for: .normal)
        button4.setTitleColor(.black, for: .normal)
        button4.addTarget(self, action: #selector(toChooseCity), for: .touchUpInside)
        self.view.addSubview(button4)
        
        let button5 = UIButton(frame: CGRect(x: 200, y: 300, width: 100, height: 30))
        button5.setTitle("选择人数", for: .normal)
        button5.setTitleColor(.black, for: .normal)
        button5.addTarget(self, action: #selector(toChoosePeople), for: .touchUpInside)
        self.view.addSubview(button5)
        
        let button6 = UIButton(frame: CGRect(x: 200, y: 400, width: 100, height: 30))
        button6.setTitle("地址联动", for: .normal)
        button6.setTitleColor(.black, for: .normal)
        button6.addTarget(self, action: #selector(toChooseCity2), for: .touchUpInside)
        self.view.addSubview(button6)
        
        let button7 = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 30))
        button7.setTitle("地图", for: .normal)
        button7.setTitleColor(.black, for: .normal)
        button7.addTarget(self, action: #selector(toMap), for: .touchUpInside)
        self.view.addSubview(button7)
        
        let button8 = UIButton(frame: CGRect(x: 200, y: 500, width: 100, height: 30))
        button8.setTitle("门票页", for: .normal)
        button8.setTitleColor(.black, for: .normal)
        button8.addTarget(self, action: #selector(toTicketPage), for: .touchUpInside)
        self.view.addSubview(button8)
        
    }

    @objc func toPhotosList() {
        let photoVC = TCHotelPhotosListManageController()
        photoVC.navTitle = "上海浦东香格里拉大酒店"
        self.navigationController?.pushViewController(photoVC, animated: true)
    }
    @objc func toCommentList() {
        let commentLVC = TCHotelCommentListController()
        commentLVC.navTitle = "住客点评"
        self.navigationController?.pushViewController(commentLVC, animated: true)
    }
    
    @objc func toOrderPage() {
        let order = TCHotelSubmitOrderViewController()
        order.navTitle = "上海浦东香格里拉大酒店"
        self.navigationController?.pushViewController(order, animated: true)
    }
    
    @objc func toChooseCity() {
        
        let destination: UIView = (Bundle.main.loadNibNamed("TCHotelDestinationView", owner: nil, options: nil)?.first) as! TCHotelDestinationView
        destination.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - 0) //125
        self.view.addSubview(destination)
    }
    
    @objc func toChoosePeople() {
        let view: TCHotelPeopleNumPickView = Bundle.main.loadNibNamed("TCHotelPeopleNumPickView", owner: self, options: nil)?.first as! TCHotelPeopleNumPickView
        view.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH) //125
        view.peopleSelectedCompleted = { dict in
            
        }
        self.view.addSubview(view)
    }
    
    @objc func toChooseCity2() {
        
        let searlocation = TCHotelSearchLocationView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH))
       
        self.view.addSubview(searlocation)
    }
    
    @objc func toMap() {
        let map = TCMapViewController()
        self.navigationController?.pushViewController(map, animated: true)
    }
    
    @objc func toTicketPage() {
        let ticket = TCTicketProductViewController()
        self.navigationController?.pushViewController(ticket, animated: true)
    }
}

