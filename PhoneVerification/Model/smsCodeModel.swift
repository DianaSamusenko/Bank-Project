//
//  smsCodeModel.swift
//  PhoneVerification
//
//  Created by Samusenko Diana on 3/3/20.
//  Copyright © 2020 Diana Samusenka. All rights reserved.
//

import Foundation
import ObjectMapper

class smsCodeModel: Mappable {
    var hash: String?
    var phoneNumber: String?
    var type: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        hash    <- map["hash"]
        phoneNumber         <- map["phoneNumber"]
        type      <- map["type"]
    }
}

