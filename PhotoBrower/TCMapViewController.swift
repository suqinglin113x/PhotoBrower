//
//  TCMapViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/9/30.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCMapViewController: UIViewController, BMKMapViewDelegate, BMKLocationManagerDelegate {
    var locationManager = BMKLocationManager()
    var mapView: BMKMapView!
    var userLocation = BMKUserLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        //设置返回位置的坐标系类型
        locationManager.coordinateType = .BMK09LL
        //设置距离过滤参数
        locationManager.distanceFilter = kCLDistanceFilterNone
        //设置预期精度参数
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //设置应用位置类型
        locationManager.activityType = .automotiveNavigation
        //设置是否自动停止位置更新
        locationManager.pausesLocationUpdatesAutomatically = false
        //设置是否允许后台定位
//        locationManager.allowsBackgroundLocationUpdates = true
        //设置位置获取超时时间
        locationManager.locationTimeout = 15
        //设置获取地址信息超时时间
        locationManager.reGeocodeTimeout = 15
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
       
        
        
        mapView = BMKMapView(frame: self.view.frame)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = BMKUserTrackingModeFollow
        let param: BMKLocationViewDisplayParam = BMKLocationViewDisplayParam.init()
        //设置显示精度圈，默认YES
        param.isAccuracyCircleShow = true
        //根据配置参数更新定位图层样式
        mapView.updateLocationView(with: param)
        // 将当前地图显示缩放等级设置为17级
        mapView?.zoomLevel = 18
        mapView?.showMapScaleBar = true
        self.view.addSubview(mapView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        locationManager.stopUpdatingLocation()
    }
    

    //MARK:BMKLocationManagerDelegate
    /**
     @brief 该方法为BMKLocationManager提供设备朝向的回调方法
     @param manager 提供该定位结果的BMKLocationManager类的实例
     @param heading 设备的朝向结果
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        NSLog("用户方向更新")
        userLocation.heading = heading
        mapView.updateLocationData(userLocation)
    }

    /**
     @brief 连续定位回调函数
     @param manager 定位 BMKLocationManager 类
     @param location 定位结果，参考BMKLocation
     @param error 错误信息。
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if let _ = error?.localizedDescription {
            NSLog("locError:%@;", (error?.localizedDescription)!)
        }
        userLocation.location = location?.location
        //实现该方法，否则定位图标不出现
        mapView.updateLocationData(userLocation)
    }

    /**
     @brief 当定位发生错误时，会调用代理的此方法
     @param manager 定位 BMKLocationManager 类
     @param error 返回的错误，参考 CLError
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        NSLog("定位失败")
    }
}

