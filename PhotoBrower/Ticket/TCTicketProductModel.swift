//
//  TCTicketProductModel.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/9.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import SwiftyJSON

struct TCTicketProductModel {
    var baseInfo: TCBaseInfo?
    var ticketModelArray: [[TCTicketModel]]? = []
    
    
}

/** baseinfo***/
struct TCBaseInfo {
    var productName: String?
    var productType: Int?
    var productTypeName: String?
    var productImageInfos: [TCBaseInfoImageInfo]? = []
    var productTagList: [TCBaseInfoTagInfo]? = []
    var passengerRule: String?
    var company: TCBaseInfoCompanyInfo?
    var unsubscribePolicyType: Int?
    init(jsonData: JSON) {
        productName = jsonData["productName"].stringValue
        productType = jsonData["productType"].intValue
        productTypeName = jsonData["productTypeName"].stringValue
        for item in jsonData["productImageInfos"].arrayValue {
            productImageInfos?.append(TCBaseInfoImageInfo(jsonData: item))
        }
        for item in jsonData["productTagList"].arrayValue {
            productTagList?.append(TCBaseInfoTagInfo(jsonData: item))
        }
        passengerRule = jsonData["passengerRule"].stringValue
        company = TCBaseInfoCompanyInfo(jsonData: jsonData["company"])
        unsubscribePolicyType = jsonData["unsubscribePolicyType"].intValue
    }
}

struct TCBaseInfoImageInfo {
    var pictureId: Int?
    var isLogo: Int?
    var url: String?
    var name: String?
    var remark: String?
    var pictureType: String?
    var sortNo: Int?
    var typeName: String?
    var sortType: Int?
    init(jsonData: JSON) {
        pictureId = jsonData["pictureId"].intValue
        isLogo = jsonData["isLogo"].intValue
        url = jsonData["url"].stringValue
        name = jsonData["name"].stringValue
        remark = jsonData["remark"].stringValue
        pictureType = jsonData["pictureType"].stringValue
        sortNo = jsonData["sortNo"].intValue
        typeName = jsonData["typeName"].stringValue
        sortType = jsonData["sortType"].intValue
    }
}

struct TCBaseInfoTagInfo {
    var productInfoId: String?
    var tagTypeId: Int?
    var tagTypeName: String?
    var type: Int?
    var producttagname: String?
    init(jsonData: JSON) {
        productInfoId = jsonData["productInfoId"].stringValue
        tagTypeId = jsonData["tagTypeId"].intValue
        tagTypeName = jsonData["tagTypeName"].stringValue
        type = jsonData["type"].intValue
        producttagname = jsonData["producttagname"].stringValue
    }
}
struct TCBaseInfoCompanyInfo {
    var companyId: Int?
    var companyName: String?
    var csCode: String?
    var tel: String?
    var urlLogo: String?
    var mqAppkey:String?
    var mqUrl: String?
    init(jsonData: JSON) {
        companyId = jsonData["companyId"].intValue
        companyName = jsonData["companyName"].stringValue
        csCode = jsonData["csCode"].stringValue
        tel = jsonData["tel"].stringValue
        urlLogo = jsonData["urlLogo"].stringValue
        mqAppkey = jsonData["mqAppkey"].stringValue
        mqUrl = jsonData["mqUrl"].stringValue

    }
}


/**explainInfo**/



/**ticketsData**/
struct TCTicketModel {
    var resourceId: Int?
    var resourceName: String?
    var startingPrice: String?
    var sort: Int?
    var singleMax: Int?
    var singleMaxText: String?
    var isRealNameKey:String?
    var isSessionKey: Int?
    var isSessionValue: String?
//    var ticketWayResDTOS:String?
//    var sessionList: String?
//    var passengerRule: String?
    init(jsonData: JSON) {
        resourceId = jsonData["resourceId"].intValue
        resourceName = jsonData["resourceName"].stringValue
        startingPrice = jsonData["startingPrice"].stringValue
        singleMaxText = jsonData["singleMaxText"].stringValue
        singleMax = jsonData["singleMax"].intValue
        sort = jsonData["sort"].intValue
        isRealNameKey = jsonData["isRealNameKey"].stringValue
        isSessionKey = jsonData["isSessionKey"].intValue
        isSessionValue = jsonData["isSessionValue"].stringValue
//        ticketWayResDTOS = jsonData["ticketWayResDTOS"].stringValue
//        sessionList = jsonData["sessionList"].stringValue
//        passengerRule = jsonData["passengerRule"].stringValue
    }
    static func arrWith(jsonData: JSON) -> [TCTicketModel] {
        var arr: [TCTicketModel] = []
        for item in jsonData.arrayValue {
            let model = TCTicketModel(jsonData: item)
            arr.append(model)
        }
        return arr
    }
}
