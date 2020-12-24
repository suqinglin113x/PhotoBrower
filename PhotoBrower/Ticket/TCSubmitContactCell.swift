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
        self.selectionStyle = .none
        
        markTV.textContainerInset = UIEdgeInsets.init(top: 10, left: -5, bottom: 0, right: 0)
    }

    
}

extension TCSubmitContactCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let limitCount = 30
        
        let lang = textView.textInputMode?.primaryLanguage
        if lang == "zh-Hans" { // 中文输入法
            if let selectedRange = textView.markedTextRange, let _ = textView.position(from: selectedRange.start, offset: 0) {
                
            } else {
                textView.text = String(textView.text.prefix(limitCount))
            }
            
        } else { // 英文其他输入法
            if textView.text.count > 30 {
                textView.text = String(textView.text.prefix(limitCount))
            }
        }
        
    }
    
}
