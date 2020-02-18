//
//  FirestoreService.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FireStoreCollections: String {
    case users
    case favTickets
    case favArts
}

enum SortingCriteria: String {
    case fromNewestToOldest = "dateCreated"
    var shouldSortAscending: Bool {
        switch self {
        case .fromNewestToOldest:
            return true
        }
        
    }
}

class FirestoreService {
    static let manager = FirestoreService()
    
    private let db = Firestore.firestore()
    
    //MARK: AppUsers
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    
    
    
    func getUserApiType(from id: String, completion: @escaping (Result<String,Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).document(id).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                let userID = snapshot.documentID
                if let user = AppUser(from: snapshot.data() ?? [:], id: userID) {
                    completion(.success(user.apiType ?? ""))
                }
            }
        }
    }
    func updateAppUser(id: String,newExperience: String,completion: @escaping (Result<(),Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).document(id).updateData(["apiType": newExperience]) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //MARK: FavTickets
    func createFaveTicket(favedTicket: FavoriteTickets, completion: @escaping (Result<(),Error>) -> ()) {
        let fields = favedTicket.fieldsDict
        db.collection(FireStoreCollections.favTickets.rawValue).document(favedTicket.id).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    func getFavTickets(completion: @escaping (Result<[FavoriteTickets],Error>) -> ()) {
        db.collection(FireStoreCollections.favTickets.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> FavoriteTickets? in
                    let ticketID = snapshot.documentID
                    let user = FavoriteTickets(from: snapshot.data(), id: ticketID)
                    return user
                })
                completion(.success(users ?? []))
            }
        }
    }
    func getFavTicketsFor(userId: String, completion: @escaping (Result<[FavoriteTickets],Error>) -> ()) {
        db.collection(FireStoreCollections.favTickets.rawValue).whereField("createdBy", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> FavoriteTickets? in
                    let ticketID = snapshot.documentID
                    let user = FavoriteTickets(from: snapshot.data(), id: ticketID)
                    return user
                })
                completion(.success(users ?? []))
            }
        }
    }
    func findIdOfUnfavored(ticket id: String, userId: String, completionHandler: @escaping (Result<String,Error>) -> ()) {
        db.collection(FireStoreCollections.favTickets.rawValue).whereField("createdBy", isEqualTo: userId).whereField("ticketId", isEqualTo: id).getDocuments { (snapshot, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                let tickets = snapshot?.documents.compactMap({ (snapshot) -> FavoriteTickets? in
                    let ticketID = snapshot.documentID
                    let ticket = FavoriteTickets(from: snapshot.data(), id: ticketID)
                    return ticket
                })
                if let tickets = tickets {
                    completionHandler(.success(tickets[0].id))
                }
            }
        }
    }
    func unfavoritedTicket(result: (Result<String,Error>), completion: @escaping (Result<(),Error>) -> ()) {
        switch result {
        case .success(let favId):
            db.collection(FireStoreCollections.favTickets.rawValue)
                .document(favId).delete { (error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
            }
        case .failure(let error):
            completion(.failure(error))
        }
        
    }
    //MARK: FavMuseumArts
    func createFaveArtwork(favedArt: FavoriteMuseumArtworks, completion: @escaping (Result<(),Error>) -> ()) {
        let fields = favedArt.fieldsDict
        db.collection(FireStoreCollections.favArts.rawValue).document(favedArt.id).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    func getFavArtworks(completion: @escaping (Result<[FavoriteMuseumArtworks],Error>) -> ()) {
        db.collection(FireStoreCollections.favArts.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let artworks = snapshot?.documents.compactMap({ (snapshot) -> FavoriteMuseumArtworks? in
                    let artId = snapshot.documentID
                    let user = FavoriteMuseumArtworks(from: snapshot.data(), id: artId)
                    return user
                })
                completion(.success(artworks ?? []))
            }
        }
    }
    func getFavArtsFor(userId: String, completion: @escaping (Result<[FavoriteMuseumArtworks],Error>) -> ()) {
        db.collection(FireStoreCollections.favArts.rawValue).whereField("createdBy", isEqualTo: userId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let artworks = snapshot?.documents.compactMap({ (snapshot) -> FavoriteMuseumArtworks? in
                    let artId = snapshot.documentID
                    let user = FavoriteMuseumArtworks(from: snapshot.data(), id: artId)
                    return user
                })
                completion(.success(artworks ?? []))
            }
        }
    }
    func findIdForUnFaved(art id: String, userId: String, completionHandler: @escaping (Result<String,Error>) -> ()) {
        db.collection(FireStoreCollections.favArts.rawValue).whereField("createdBy", isEqualTo: userId).whereField("objectId", isEqualTo: id).getDocuments { (snapshot, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                let artworks = snapshot?.documents.compactMap({ (snapshot) -> FavoriteMuseumArtworks? in
                    let artId = snapshot.documentID
                    let art = FavoriteMuseumArtworks(from: snapshot.data(), id: artId)
                    return art
                })
                if let artworks = artworks {
                    completionHandler(.success(artworks[0].id))
                }
            }
        }
        
    }
    func unfavoritedArt(result: (Result<String,Error>),completion: @escaping (Result<(),Error>) ->()) {
        switch result {
        case .success(let favArtId):
            db.collection(FireStoreCollections.favArts.rawValue).document(favArtId).delete { (error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    
    private init () {}
}
