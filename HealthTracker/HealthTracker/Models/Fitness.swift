//
//  Fitness.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Foundation
import ObjectMapper

class Fitness: Mappable, Codable {

    var id: String?
    var age: Int?
    var weigth: Double?
    var heigth: Double?
    var stamina: String?
    var strength: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        age <- map["age"]
        weigth <- map["weigth"]
        heigth <- map["heigth"]
        stamina <- map["stamina"]
        strength <- map["strength"]
    }
}
