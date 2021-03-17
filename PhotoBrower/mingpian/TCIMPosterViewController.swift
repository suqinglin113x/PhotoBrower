//
//  TCIMPosterViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/3/16.
//  Copyright © 2021 苏庆林. All rights reserved.
//

import UIKit
private let kScreenW: CGFloat = UIScreen.main.bounds.size.width

class TCIMPosterViewController: UIViewController {

    private var backButton: UIButton! = {
        let b = UIButton()
        let statusH: CGFloat = UIApplication.shared.statusBarFrame.height
        b.frame = CGRect(x: 10, y: statusH, width: 44, height: 44)
        b.setImage(UIImage.init(named: "back_white"), for: .normal)
        b.setImage(UIImage.init(named: "back_white"), for: .highlighted)
        b.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        return b
    }()
    
    private var backImageView: UIImageView! = {
       let iv = UIImageView()
        let h: CGFloat = kScreenW*(803/750)
        iv.frame = CGRect(x: 0, y: 0, width: kScreenW, height: h)
        iv.sd_setImage(with: URL(string: "https://foliday-img.oss-cn-shanghai.aliyuncs.com/tc-poster/tc-poster/bg.jpg"), completed: nil)
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(backImageView)
        self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        self.view.addSubview(backButton)
        
    }
    

    @objc func closeVC() {
        self.navigationController?.popViewController(animated: true)
    }

}
