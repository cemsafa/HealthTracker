//
//  User.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-09.
//

import Foundation
import ObjectMapper

class User: Mappable, Codable {

    var id: String?
    var name: String?
    var email: String?
    var bloodpressures: [BloodPressure]?
    var bloodsugars: [BloodSugar]?
    var heartrates: [HeartRate]?
    var fitnesses: [Fitness]?
    var familymembers: [FamilyMember]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        email <- map["email"]
        bloodpressures <- map["bloodpressures"]
        bloodsugars <- map["bloodsugars"]
        heartrates <- map["heartrates"]
        fitnesses <- map["fitnesses"]
        familymembers <- map["familymembers"]
    }
}
