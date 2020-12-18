//
//  GlobalUtils.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/17.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
import MBProgressHUD

class GlobalUtils: NSObject {
    private static let _instance: GlobalUtils = GlobalUtils()
    
    static var Instance: GlobalUtils {
        return _instance;
    }

    public func showToastAddTo(_ view: UIView, title: String, duration: TimeInterval) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = title
        hud.label.numberOfLines = 2
        hud.hide(animated: true, afterDelay: duration)
    }
}
