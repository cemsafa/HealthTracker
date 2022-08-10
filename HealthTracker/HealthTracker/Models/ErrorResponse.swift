//
//  ErrorResponse.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-10.
//

import Foundation
import ObjectMapper

class ErrorResponse: Mappable, Codable {

    var message: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
    }
}
