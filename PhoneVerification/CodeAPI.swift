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
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

//var accountProvider: MoyaProvider<CodeAPI> {
//    let authProvider = MoyaProvider<CodeAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter), AuthTokenPlugin()])
//
//    return authProvider
//}

extension CodeAPI: TargetType {
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var baseURL: URL { return URL(string: "https://04b32hbx0e.execute-api.eu-central-1.amazonaws.com/dev/v1/references/jurisdiction/transferPro/countries")! }
    
//    https://04b32hbx0e.execute-api.eu-central-1.amazonaws.com/dev/v1/references/jurisdiction/UK/countries
//    https://04b32hbx0e.execute-api.eu-central-1.amazonaws.com/dev/v1/references/jurisdiction/transferPro/countries
    var path: String {
        switch self {
        case .codes:
            return ""
          
        }
    }
    
    var method: Moya.Method {
        return .get
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
        }
    }
}