//
//  Helper.swift
//  HealthTracker
//
//  Created by Cem Safa on 2022-08-12.
//

import Foundation

class Helper {
    class func getLocalDate(from dateString: String?) -> String? {
        guard let stringDate = dateString else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: stringDate)
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date!)
        return localDate
    }
}
