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
    
    
     var textFieldEndEdit: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        markTV.textContainerInset = UIEdgeInsets.init(top: 10, left: -5, bottom: 0, right: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tc_textFieldDidChanged), name: UITextField.textDidChangeNotification, object: contactPhoneTF)
    }

    
}

extension TCSubmitContactCell: UITextViewDelegate, UITextFieldDelegate {
    
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
    func textViewDidEndEditing(_ textView: UITextView) {
        if textFieldEndEdit != nil {
            textFieldEndEdit!()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textFieldEndEdit == nil {
            return
        }

        textFieldEndEdit!()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    @objc func tc_textFieldDidChanged(noti: Notification) {
        let tf = noti.object as! UITextField
        if tf.text?.count ?? 0 > 11 {
            tf.text = tf.text?.prefix(11).description
        }
    }
}
