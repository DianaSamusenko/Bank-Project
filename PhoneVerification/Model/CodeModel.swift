//
//  CodeModel.swift
//  PhoneVerification
//
//  Created by Diana Samusenka on 2/26/20.
//  Copyright © 2020 Diana Samusenka. All rights reserved.
//

import Foundation
import ObjectMapper

class CodeModel: Mappable {
    var name: String?
    var imageUrl: String?
    var phoneFormats: [PhoneFormats]?
    var selected: Bool = true
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name    <- map["name"]
        imageUrl         <- map["imageUrl"]
        phoneFormats      <- map["phoneFormats"]
    }
}

class PhoneFormats: Mappable {
    var code: String?
    var mask: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        code    <- map["code"]
        mask         <- map["mask"]
    }
}


