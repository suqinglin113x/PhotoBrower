//
//  TCTravellerListViewController.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/25.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCTravellerListViewController: UIViewController {
    var chooseTravellerCompleted: ((_ travellerNum: Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


   

    @IBAction func sureBtnClickAction(_ sender: Any) {
        if self.chooseTravellerCompleted != nil {
            self.chooseTravellerCompleted!(2)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

