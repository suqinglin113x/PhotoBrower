//
//  TCIMCustomerModel.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/3/17.
//  Copyright © 2021 苏庆林. All rights reserved.
// 啊哈哈哈

import Foundation

@objcMembers class TCIMCustomerModel:NSObject, Codable {

    var memberId: Int? = -1
    @objc var isChatted: Bool = false
    var lastMessageTime: String?
    var name: String?
    var avatarUrl: String?
    var timId: String?
    
    static func arrayWithData(arr: Any) -> [TCIMCustomerModel] {
        var temArr: [TCIMCustomerModel] = []
        guard let a = arr as? [Any] else { return []}
        a.forEach { (item) in
            if let data = try? JSONSerialization.data(withJSONObject: item, options: []) {
                do {
                    let model = try JSONDecoder().decode(TCIMCustomerModel.self, from: data)
                    temArr.append(model)
                } catch  {
                    debugPrint(error)
                }
            }
        }
        
        return temArr
    }
}
