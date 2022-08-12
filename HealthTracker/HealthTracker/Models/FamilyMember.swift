//
//  FamilyMember.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Foundation
import ObjectMapper

class FamilyMember: Mappable, Codable {

    var id: String?
    var userId: String?
    var memberId: String?
    var createdAt: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        userId <- map["userId"]
        memberId <- map["memberId"]
        createdAt <- map["createdAt"]
    }
}

class FamilyMemberSelf: Mappable, Codable {
    
    var data: [FamilyMember]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}
