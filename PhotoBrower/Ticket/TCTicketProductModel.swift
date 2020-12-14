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
    var adBannerModel: TCAdBannerModel?
    
}

/** baseinfo***/
struct TCBaseInfo: Codable {
    var productCode: String?
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
        dataArr.forEach { (item) in
            if let data = try? JSONSerialization.data(withJSONObject: item, options: []) {
                do {
                    let model = try JSONDecoder().decode(TCTicketModel.self, from: data)
                    arr.append(model)
                } catch {
                    print(error)
                }
            }
        }
        
        return arr
    }
}

/**AdBannerData**/
struct TCAdBannerModel: Codable {
    var activityUrl: String?
    var productId: Int?
    var entranceImg: String?
    var subscriptInfo:String?
   
}

/**CMSData**/
struct TCCMSModel: Codable {
    var themePicUri: String?
    var jumpPath: String?
   
    static func arrWith(dataArr: Any) -> [TCCMSModel] {
        var arr: [TCCMSModel] = []
        guard let dataArr = dataArr as? [[String: Any]]  else { return [] }
        dataArr.forEach { (item) in
            let componentContent = (item["componentContents"] as? NSArray)?.firstObject
            if let data = try? JSONSerialization.data(withJSONObject: componentContent as Any, options: []) {
                do {
                    let model = try JSONDecoder.init().decode(TCCMSModel.self, from: data)
                    arr.append(model)
                }
                catch {
                    print(error)
                }
            }
        }
        return arr
    }
}


/* coupon*/
struct TCCouponModel: Codable {
    var couponId: Int?
    var cpName: String?
    var validDayNum: Int?
    var validDayStart: Int?
    var type: Int? // 2折扣券1现金券4门票抵用券
    var denomination: Int?
    var startTime: Double?
    var endTime: Double?
    var rule: String?
    var discount: Double?
    var ticketNum: Int?
    var couponStr: String?
    
    static func arrWith(dataArr: Any) -> [TCCouponModel] {
        var arr: [TCCouponModel] = []
        guard let dataArr = dataArr as? [[String: Any]]  else { return [] }
        dataArr.forEach { (item) in
            
            if let data = try? JSONSerialization.data(withJSONObject: item as Any, options: []) {
                do {
                    let model = try JSONDecoder.init().decode(TCCouponModel.self, from: data)
                    arr.append(model)
                } catch  {
                    print(error)
                }
                
            }
        }
        return arr
    }
    
}
