//
//  FavTicketsPersistance.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/3/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
class FavTicketsPersistence {
    private init() {}
    static let manager = FavTicketsPersistence()
    private let persistanceHelper = PersistenceHelper<Event>.init(fileName: "Tickets.plist")
    
    func save(newElement: Event) throws {
        try persistanceHelper.save(newElement: newElement)
    }
    func delete(at id: String) throws {
        let favs = try persistanceHelper.getObjects()
        let newfavs = favs.filter { (event) -> Bool in
            return event.id != id
        }
        try persistanceHelper.replace(arrOfElements: newfavs)
    }
    func getObjects() throws -> [Event] {
        try persistanceHelper.getObjects()
    }
}
