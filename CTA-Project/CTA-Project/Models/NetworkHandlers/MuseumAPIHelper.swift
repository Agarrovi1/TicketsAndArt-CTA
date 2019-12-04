//
//  MuseumAPIHelper.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/4/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
class MuseumAPIHelper {
    private init() {}
    static var manager = MuseumAPIHelper()
    
    func getArtObjects(query:String, completionHandler: @escaping (Result<[ArtObject],AppError>) ->()) {
        let urlString = Secrets.makeMuseumUrlString(query: query)
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let museumArt = try JSONDecoder().decode(MuseumArt.self, from: data)
                    completionHandler(.success(museumArt.artObjects))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
}
