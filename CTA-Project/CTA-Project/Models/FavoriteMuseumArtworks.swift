//
//  FavoriteMuseumArtworks.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
struct FavoriteMuseumArtworks {
    let id: String
    let createdBy: String?
    let principleMaker: String?
    let imageUrl: String?
    let title: String?
    let objectId: String?
    
    init(createdBy: String, principleMaker: String, imageUrl: String, objectId: String, title: String) {
        self.id = UUID.init().description
        self.createdBy = createdBy
        self.principleMaker = principleMaker
        self.imageUrl = imageUrl
        self.title = title
        self.objectId = objectId
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let createdBy = dict["createdBy"] as? String,
            let principleMaker = dict["principleMaker"] as? String,
            let imageUrl = dict["imageUrl"] as? String,
        let title = dict["title"] as? String,
        let objectId = dict["objectId"] as? String else { return nil }
        
        self.createdBy = createdBy
        self.id = id
        self.principleMaker = principleMaker
        self.imageUrl = imageUrl
        self.title = title
        self.objectId = objectId
    }
    
    var fieldsDict: [String: Any] {
        return [
            "createdBy": self.createdBy ?? "",
            "principleMaker": self.principleMaker ?? "",
            "imageUrl": self.imageUrl ?? "",
            "title": self.title ?? "",
            "objectId": self.objectId ?? ""
        ]
    }
}
