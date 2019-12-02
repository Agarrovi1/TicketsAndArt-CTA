//
//  AppUser.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct AppUser {
    let email: String?
    let uid: String
    let dateCreated: Date?
    let apiType: String?
    
    init(from user: User,apiType: String) {
        self.email = user.email
        self.uid = user.uid
        self.dateCreated = user.metadata.creationDate
        self.apiType = apiType
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let apiType = dict["apiType"] as? String,
            let email = dict["email"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else { return nil }
        
        self.apiType = apiType
        self.email = email
        self.uid = id
        self.dateCreated = dateCreated
    }
    
    var fieldsDict: [String: Any] {
        return [
            "apiType": self.apiType ?? "",
            "email": self.email ?? ""
        ]
    }
}
