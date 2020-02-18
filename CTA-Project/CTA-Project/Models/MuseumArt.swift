//
//  MuseumArt.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
struct MuseumArt: Codable {
    let artObjects: [ArtObject]
}
struct ArtObject: Codable {
    let id, objectNumber, title: String
    let hasImage: Bool
    let principalOrFirstMaker, longTitle: String
    let webImage: WebImage?
    let productionPlaces: [String]
}

struct WebImage: Codable {
    let url: String?
}

//MARK: Details
struct MuseumArtDetail: Codable {
    let artObject: ArtDetail
    
    
}

struct ArtDetail: Codable {
    let plaqueDescriptionEnglish: String
}

