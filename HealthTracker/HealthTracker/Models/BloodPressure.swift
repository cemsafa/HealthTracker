//
//  BloodPressure.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Foundation
import ObjectMapper

class BloodPressure: Mappable, Codable {

    var id: String?
    var systolic: Int?
    var diastolic: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        systolic <- map["systolic"]
        diastolic <- map["diastolic"]
    }
}
