//
//  AppDelegate.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
private let BMapKey = "MEKCdfEMISNNX7VGCXC8IgPSM7SZvQQL"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKLocationAuthDelegate, BMKGeneralDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #warning("必须和注册时的bundle identifier 一致")
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: BMapKey, authDelegate: self)
        // 地图
        let mapManager = BMKMapManager()
        if mapManager.start(BMapKey, generalDelegate: self) {
        } else {
            debugPrint("错误")
        }
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_BD09LL) {
            NSLog("经纬度类型设置成功")
        } else {
            NSLog("经纬度类型设置失败")
        }
        
        return true
    }

   
}

