//
//  CodeAPI.swift
//  PhoneVerification
//
//  Created by Diana Samusenka on 2/26/20.
//  Copyright © 2020 Diana Samusenka. All rights reserved.
//

import Foundation
import Moya

enum CodeAPI {
    case codes
    case smsCodes(hash: String, phoneNumber: String, type: String)
    case checkSmsCode(code: String, phoneNumber: String)
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data 
    }
}

extension CodeAPI: TargetType {
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var baseURL: URL { return URL(string: "https://04b32hbx0e.execute-api.eu-central-1.amazonaws.com/dev/")!
    }
    
    var path: String {
        switch self {
        case .codes:
            return "v1/references/jurisdiction/transferPro/countries"
        case .smsCodes:
            return "v1/signup-processes"
        case .checkSmsCode:
            return "v1/signup-processes/ /phone-verifications"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .codes:
            return .get
        case .smsCodes:
            return .post
        case .checkSmsCode:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    public var validationType: ValidationType {
        switch self {
        default:
            return .successCodes
        }
    }
    
    var task: Task {
        switch self {
        case .codes:
            return .requestPlain
        case let .smsCodes(hash, phoneNumber, type):
            var a =
            [
                "hash": "",
                "phoneNumber": phoneNumber,
                "type": "SMS"]
            return .requestJSONEncodable(a)
        case let .checkSmsCode(code, phoneNumber):
            var a =
            [
                "code": code,
                "phoneNumber": phoneNumber]
            return .requestJSONEncodable(a)
        }
    }
}
