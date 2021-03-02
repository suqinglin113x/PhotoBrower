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
class AppDelegate: UIResponder, UIApplicationDelegate, BMKLocationAuthDelegate, BMKGeneralDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #warning("必须和注册时的bundle identifier 一致")
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: BMapKey, authDelegate: self)
        // 地图
//        let mapManager = BMKMapManager()
//        if mapManager.start(BMapKey, generalDelegate: self) {
//        } else {
//            debugPrint("错误")
//        }
//        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_BD09LL) {
//            NSLog("经纬度类型设置成功")
//        } else {
//            NSLog("经纬度类型设置失败")
//        }
        
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey("603c7b4eaa055917f898d9eb", channel: "App Store")
        let entity = UMessageRegisterEntity()
       
        UNUserNotificationCenter.current().delegate = self
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity, completionHandler: { granted, error in
            if granted {
            } else {
                
            }
        })
        
        return true
    }

   
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        var token = deviceToken.description.replacingOccurrences(of: "<", with: "")
//        token = token.replacingOccurrences(of: ">", with: "")
//        token = token.replacingOccurrences(of: " ", with: "")
//        print("token push : \(token)")
        
        
        let token = deviceToken.map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
        print("token push : \(token)")
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UMessage.didReceiveRemoteNotification(userInfo)
        
    }
    
    @available(iOS 10.0, *)
    //iOS10新增：处理前台收到通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            let info = userInfo as NSDictionary
            print(info)
            //应用处于前台时的远程推送接受
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
        }else{
            //应用处于前台时的远程推送接受
        }
        completionHandler([.alert,.sound,.badge])
    }
    
    
    @available(iOS 10.0, *)
    //iOS10新增：处理后台点击通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            let info = userInfo as NSDictionary
            print(info)
            
            UMessage.didReceiveRemoteNotification(userInfo)
        }else{
            //应用处于前台时的远程推送接受
        }
    }
    
}

