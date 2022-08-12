//
//  HeartRate.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Foundation
import ObjectMapper

class HeartRate: Mappable, Codable {

    var id: String?
    var bpm: Int?
    var createdAt: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        bpm <- map["bpm"]
        createdAt <- map["createdAt"]
    }
}

class HeartRateSelf: Mappable, Codable {
    
    var data: [HeartRate]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
    }
}
