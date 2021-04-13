//
//  OtherViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/4/2.
//  Copyright © 2021 苏庆林. All rights reserved.
//

import UIKit
import os
import OSLog

class OtherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        if #available(iOS 13.0, *) {
            let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: .dynamicTracing)
            os_log("啥啥啥山东省", log: log, type: .info)
            os_log("WeiXin resp type: %@",log:log , "苏庆林")
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    

    
}
