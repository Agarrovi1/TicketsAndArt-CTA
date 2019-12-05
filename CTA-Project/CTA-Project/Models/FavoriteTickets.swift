//
//  FavoriteTickets.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/3/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
struct FavoriteTickets {
    let id: String
    let createdBy: String?
    let startDate: String?
    let imageUrl: String?
    let name: String?
    let ticketId: String?
    
    init(createdBy: String, startDate: String, imageUrl: String, ticketId: String, name: String) {
        self.id = UUID.init().description
        self.createdBy = createdBy
        self.startDate = startDate
        self.imageUrl = imageUrl
        self.name = name
        self.ticketId = ticketId
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let createdBy = dict["createdBy"] as? String,
            let startDate = dict["startDate"] as? String,
        let imageUrl = dict["imageUrl"] as? String,
        let name = dict["name"] as? String,
        let ticketId = dict["ticketId"] as? String else { return nil }
        self.createdBy = createdBy
        self.id = id
        self.startDate = startDate
        self.imageUrl = imageUrl
        self.name = name
        self.ticketId = ticketId
    }
    
    var fieldsDict: [String: Any] {
        return [
            "createdBy": self.createdBy ?? "",
            "startDate": self.startDate ?? "",
            "imageUrl": self.imageUrl ?? "",
            "name": self.name ?? "",
            "ticketId": self.ticketId ?? ""
        ]
    }
}
