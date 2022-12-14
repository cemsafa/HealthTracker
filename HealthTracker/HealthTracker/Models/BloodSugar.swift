//
//  BloodSugar.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Foundation
import ObjectMapper

class BloodSugar: Mappable, Codable {

    var id: String?
    var glucose: Int?
    var createdAt: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        glucose <- map["glucose"]
        createdAt <- map["createdAt"]
    }
}

class BloodSugarSelf: Mappable, Codable {
    
    var data: [BloodSugar]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}
