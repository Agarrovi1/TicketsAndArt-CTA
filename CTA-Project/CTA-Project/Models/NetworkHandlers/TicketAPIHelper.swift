//
//  TicketAPIHelper.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/3/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
class TicketAPIHelper {
    private init() {}
    static let manager = TicketAPIHelper()
    
    func getEvents(query: String, completionHandler: @escaping (Result<[Event],AppError>) -> ()) {
        let urlString = Secrets.makeTicketURL(query: query)
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
                    let wrapper = try JSONDecoder().decode(TicketMasterWrapper.self, from: data)
                    if wrapper.page.totalPages == 0 {
                        completionHandler(.failure(.noSearchResults))
                    }
                    
                    completionHandler(.success(wrapper.embedded.events))
                    
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
}
