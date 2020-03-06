//
//  GetSmsModel.swift
//  PhoneVerification
//
//  Created by Diana Samusenko on 3/5/20.
//  Copyright © 2020 Diana Samusenka. All rights reserved.
//

import Foundation
import ObjectMapper

class GetSmsModel: Mappable {
    var phoneMask: String?
    var processId: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        phoneMask <- map["phoneMask"]
        processId <- map["processId"]
    }
}
