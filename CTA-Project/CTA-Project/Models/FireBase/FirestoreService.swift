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
    
    func updateCurrentUser(userName: String? = nil, photoURL: URL? = nil, completion: @escaping (Result<(), Error>) -> ()){
        guard let userId = FirebaseAuthService.manager.currentUser?.uid else {
            return
        }
        var updateFields = [String:Any]()
        
        if let user = userName {
            updateFields["userName"] = user
        }
        
        if let photo = photoURL {
            updateFields["photoURL"] = photo.absoluteString
        }
        //PUT request
        db.collection(FireStoreCollections.users.rawValue).document(userId).updateData(updateFields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    }
    
    func getAllUsers(completion: @escaping (Result<[AppUser], Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> AppUser? in
                    let userID = snapshot.documentID
                    let user = AppUser(from: snapshot.data(), id: userID)
                    return user
                })
                completion(.success(users ?? []))
            }
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
    func updateAppUser(id: String,newDisplayName: String,completion: @escaping (Result<(),Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).document(id).updateData(["userName": newDisplayName]) { (error) in
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
    func unfavoritedTicket(ticketId: String, completion: @escaping (Result<(),Error>) ->()) {
        db.collection(FireStoreCollections.favTickets.rawValue).document(ticketId).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
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
    func unfavoritedArt(objectId: String, completion: @escaping (Result<(),Error>) ->()) {
        db.collection(FireStoreCollections.favArts.rawValue).document(objectId).delete { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    private init () {}
}
