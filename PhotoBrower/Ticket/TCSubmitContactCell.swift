//
//  TCSubmitContactCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/23.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class TCSubmitContactCell: UITableViewCell {
    
    @IBOutlet weak var contactNameTF: UITextField!
    @IBOutlet weak var contactPhoneTF: UITextField!
    
    @IBOutlet weak var markTV: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    
}

extension TCSubmitContactCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {

    }
}
