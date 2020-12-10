//
//  TCTicketProductModel.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/9.
//  Copyright © 2020 苏庆林. All rights reserved.
//


struct TCTicketProductModel {
    var baseInfo: TCBaseInfo?
    var ticketModelArray: [[TCTicketModel]]? = []
    
    
}

/** baseinfo***/
struct TCBaseInfo: Codable {
    var productName: String?
    var productType: Int?
    var productTypeName: String?
    var productImageInfos: [TCBaseInfoImageInfo]? = []
    var productTagList: [TCBaseInfoTagInfo]? = []
    var passengerRule: String?
    var company: TCBaseInfoCompanyInfo?
    var unsubscribePolicyType: Int?
}

struct TCBaseInfoImageInfo: Codable {
    var pictureId: Int?
    var isLogo: Int?
    var url: String?
    var name: String?
    var remark: String?
    var pictureType: String?
    var sortNo: Int?
    var typeName: String?
    var sortType: Int?
}

struct TCBaseInfoTagInfo: Codable {
    var productInfoId: String?
    var tagTypeId: Int?
    var tagTypeName: String?
    var type: Int?
    var producttagname: String?
}
struct TCBaseInfoCompanyInfo: Codable {
    var companyId: Int?
    var companyName: String?
    var csCode: String?
    var tel: String?
    var urlLogo: String?
    var mqAppkey:String?
    var mqUrl: String?

}


/**explainInfo**/



/**ticketsData**/
struct TCTicketModel: Codable {
    var resourceId: Int?
    var resourceName: String?
    var startingPrice: String?
    var sort: Int?
    var singleMax: Int?
    var singleMaxText: String?
    var isRealNameKey:String?
    var isSessionKey: Int?
    var isSessionValue: String?
   
    static func arrWith(dataArr: Any) -> [TCTicketModel] {
        var arr: [TCTicketModel] = []
        guard let dataArr = dataArr as? [Any]  else { return [] }
        for item in dataArr {
            if let data = try? JSONSerialization.data(withJSONObject: item, options: []) {
                let model = try! JSONDecoder().decode(TCTicketModel.self, from: data)
                arr.append(model)
            }
        }
        
        return arr
    }
}
