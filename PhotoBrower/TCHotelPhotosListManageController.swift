//
//  TCHotelPhotosListManageController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit


private let isIphoneX = ((UIScreen.main.bounds.size.height >= 812) ? true : false)

class TCHotelPhotosListManageController: UIViewController {
    var navTitle: String?
    
    var statusH: CGFloat = {
        var statusH: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusH = (UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.size.height)!
        } else {
            statusH = UIApplication.shared.statusBarFrame.height
        }
        return statusH
    }()
   
    lazy var customNavHeader: UIView = {
        
        let navHeader = UIView()
        navHeader.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: isIphoneX ? 88 : 64)
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: statusH, width: 44, height: 44)
        backButton.setImage(UIImage.init(named: "back_black"), for: .normal)
        backButton.addTarget(self,action:#selector(closeVC),for:.touchUpInside)
        navHeader.addSubview(backButton)
        
        let titleL = UILabel()
        titleL.frame = CGRect(x: 0, y: backButton.frame.origin.y, width: view.bounds.size.width - 44*2, height: 44)
        titleL.center = CGPoint(x: view.bounds.size.width*0.5, y: backButton.center.y)
        titleL.text = self.navTitle
        titleL.textColor = .black
        titleL.textAlignment = .center
        titleL.font = UIFont(name: "PingFangSC-Semibold", size: 17)
        navHeader.addSubview(titleL)
        
        return navHeader
    }()
    
    // 三方控件
    private lazy var viewControllers: [TCHotelPhotosListController] = {
        var arr: [TCHotelPhotosListController]? = []
        for (index, title) in self.titles.enumerated() {
            let vc = TCHotelPhotosListController()
            arr?.append(vc)
        }
        return arr ?? []
    }()
    
    private var titles: [String] = ["全部 100", "外观 25", "房间 86", "餐饮 9"]
    
    private lazy var layout: LTLayout = {
      let layout = LTLayout()
        layout.sliderHeight = 40
        layout.lrMargin = 15
        layout.scale = 1.1
        layout.titleFont = UIFont.init(name: "PingFangSC-Regular", size: 13)
        layout.titleViewBgColor = .white
        layout.titleColor = UIColor(red:51/255.0, green:51/255.0, blue:51/255.0, alpha:1.0)
        layout.titleSelectColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        layout.bottomLineColor = UIColor(red:255/255.0, green:204/255.0, blue:0/255.0, alpha:1.0)
        layout.isHiddenPageBottomLine = true
        layout.pageBottomLineHeight = 0
        return layout
    }()
    
    private lazy var pageView: LTPageView = {
        let frame = CGRect(x: 0, y: statusH + 44, width: view.bounds.size.width, height: view.bounds.size.height - statusH - 44)
        let pageView = LTPageView.init(frame: frame, currentViewController: self, viewControllers: self.viewControllers, titles: self.titles, layout: self.layout)
        pageView.isClickScrollAnimation = true
        let lineV = UIView()
        lineV.frame = CGRect(x: 0, y: self.layout.sliderHeight, width: view.bounds.size.width, height: 1)
        lineV.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        pageView.addSubview(lineV)
        return pageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.view.addSubview(customNavHeader)
        self.view.addSubview(pageView)
        
    }
    


}

extension TCHotelPhotosListManageController {
    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
