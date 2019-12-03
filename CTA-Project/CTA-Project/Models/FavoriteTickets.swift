//
//  FavoriteTickets.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/3/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
class FavoriteTickets: Codable {
    
    var events: [Event]
    
    init(events: [Event]) {
        self.events = events
    }
}
