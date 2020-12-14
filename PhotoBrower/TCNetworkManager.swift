//
//  TCNetworkManager.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/7.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


#if DEBUG
let fosunholidayHost = "http://admintest.fosunholiday.com"

#else
let fosunholidayHost = "https://apis.folidaymall.com"

#endif

typealias SuccessWithSwiftyJSONType = (_ result: JSON) -> Void
typealias SuccessWithDataType = (_ result: Any?, _ data: Data?) -> Void
typealias SuccessType = (_ result: Any?) -> Void
typealias FailureType = (Error) -> Void

class TCNetworkManager {
    static var Instance: TCNetworkManager {
        return TCNetworkManager()
    }
    let sessionManager: Session = {
        
        let configuration = URLSessionConfiguration.af.default
        configuration.httpMaximumConnectionsPerHost = 8
        configuration.timeoutIntervalForRequest = 30
        
        return Session(configuration: configuration)
    }()
    
    
    
    
    public func get(URLString: String, parameters: Parameters?, success: SuccessType?, failure: FailureType?) {
        dataWithHTTPMethod(method: .get, URLString: URLString, parameters: parameters, encoding: URLEncoding.default, success: { (value) in
            guard success != nil else {
                return
            }
            success!(value)
        }) { (error) in
            guard failure != nil else {
                return
            }
            failure!(error)
        }
    }
    
    public func getWithSwiftyJSONResponse(URLString: String, parameters: Parameters?, success: SuccessWithSwiftyJSONType?, failure: FailureType?) {
        dataWithHTTPMethod(method: .get, URLString: URLString, parameters: parameters, encoding: URLEncoding.default, success: { (response) in
            guard success != nil else {
                return
            }
            
            success!(JSON(response as Any))
        }) { (error) in
            guard failure != nil else {
                return
            }
            failure!(error)
        }
    }
    
    
    
    
    public func post(URLString: String, parameters: Parameters?, success: SuccessType?, failure: FailureType?) {
        dataWithHTTPMethod(method: .post, URLString: URLString, parameters: parameters, encoding: JSONEncoding.default) { (response) in
            success!(response)
        } failure: { (error) in
            failure!(error)
        }

    }
    
    public func postWithSwiftyJSONResponse(URLString: String, parameters: Parameters?, success: (SuccessWithSwiftyJSONType)?, failure: FailureType?) {
        dataWithHTTPMethod(method: .get, URLString: URLString, parameters: parameters, encoding: URLEncoding.default, success: { (response) in
            
            guard success != nil else {
                return
            }
            let res = JSON(response as Any)
            success!(res)
        }) { (error) in
            debugPrint(error)
            guard failure != nil else {
                return
            }
            failure!(error)
        }
    }
    
    
    func dataWithHTTPMethod(method: HTTPMethod, URLString: String, parameters: Parameters?,encoding: ParameterEncoding, success: SuccessType? = nil, successWithData: SuccessWithDataType? = nil, failure: FailureType?) {
        debugPrint("请求地址：\(URLString)")
        var header: HTTPHeaders = ["Accept": "application/json",
                                   "Content-Type": "application/json",
                                   "vision": "1.0.0",
                                   "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJjcmVhdGVkIjoxNjA1NTAzMTg2MjIxLCJ0b2tlbkpzb24iOiJ7XCJhY2NvdW50XCI6XCIxMzI2MTY2OTk2NVwiLFwiYWxpcGF5VXNlclRva2VuXCI6e30sXCJhcHBLZXlcIjpcIkFQUF9UQ1wiLFwiaXNWU3VwZXJWaXBcIjpmYWxzZSxcIm1lbWJlckNyZWF0ZVRpbWVcIjoxNTkxOTQyODA5Mzg4LFwibWVtYmVySWRcIjoxMDA4NjkxOSxcIm1lbWJlckxldmVsXCI6MSxcIm1vYmlsZVwiOlwiMTMyNjE2Njk5NjVcIixcIm5hbWVDaFwiOlwiMTMyKioqKjk5NjVcIixcInNvdXJjZVR5cGVcIjowLFwidGhpcmRNZW1iZXJzXCI6W10sXCJ3eFVzZXJUb2tlblwiOnt9fSIsImV4cCI6MzQ5NzY2MzE4NiwibWVtYmVySWQiOiIxMDA4NjkxOSJ9.OjJGFGFR-KG9SsGTCo22lC-3ViOrrW91nPHDCnyYG0g0_AfTfZ9IAhdt5ZekxOVQUzEO_28hD3WQliNAz2xqhw"]
        
        var clientInfo = [
            "client_key": "tc_app_iOS",
            "client_name": "tc_app_iOS",
            "os": "iOS",
            "app_key": "APP_TC",
            "os_version":UIDevice.current.systemVersion,
            "language":"zh-CN"
        ]
        
        clientInfo["app_version"] = "4.4.5"
        
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(clientInfo) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                header["X-Call-Client-Info"] = jsonString
            }
        }
        
        let request = AF.request(URLString, method: method, parameters: parameters, encoding: encoding, headers: header)
        
        request.responseJSON { (response) in
            guard success != nil else {
                return
            }
            switch response.result {
            case .success(let json):
                debugPrint("请求接口通了")
                guard success != nil || successWithData != nil else {
                    fatalError("success and successWithData cannot be nil at same time")
                }
                if let cb = success {
                    cb(json)
                } else {
                    if let cb = successWithData {
                        cb(json, response.data)
                    }
                }
                break
            case .failure(let error):
                
                debugPrint("请求接口有误")
                debugPrint(error)
                guard failure != nil else {
                    return
                }
                failure!(error)
                break
            }
            
        }
    }
    
    
}
