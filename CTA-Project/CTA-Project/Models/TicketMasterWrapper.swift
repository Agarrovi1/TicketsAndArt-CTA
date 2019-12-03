//
//  TicketMasterWrapper.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/3/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
struct TicketMasterWrapper: Codable {
    let embedded: EventWrapper
    let page: Page
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
    }
}

struct EventWrapper: Codable {
    let events: [Event]
}

struct Event: Codable {
    let name: String
    let id: String
    let url: String
    let images: [ImageWrapper]
    let dates: DatesWrapper
    
    func getFormattedDate() -> String {
        let beforeDateFormatter = DateFormatter()
        beforeDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let afterDateFormatter = DateFormatter()
        afterDateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        if let date = beforeDateFormatter.date(from: dates.start.dateTime) {
            return afterDateFormatter.string(from: date)
        }
        return ""
            
    }
}

struct ImageWrapper: Codable {
    let url: String
}

struct DatesWrapper: Codable {
    let start: Start
}

struct Start: Codable {
    let dateTime: String
    let localDate: String
    let localTime: String
}

struct Page: Codable {
    let totalPages: Int
}
