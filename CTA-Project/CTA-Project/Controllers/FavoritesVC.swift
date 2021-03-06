//
//  FavoritesVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
    //MARK: - Properties
    var apiType: String = "" {
        didSet {
            navigationItem.title = "Favorite \(apiType)"
            DispatchQueue.main.async {
                if self.apiType == Experience.ticketmaster.rawValue {
                    self.loadFavTickets()
                } else if self.apiType == Experience.rijksmuseum.rawValue {
                    self.loadFavArtworks()
                }
            }
            
        }
    }
    
    var favoriteTickets = [FavoriteTickets]() {
        didSet {
            favTableView.reloadData()
        }
    }
    var favoriteArtObjects = [FavoriteMuseumArtworks]() {
        didSet {
            favTableView.reloadData()
        }
    }
    
    //MARK: - Objects
    var favTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.register(ListCell.self, forCellReuseIdentifier: "favCell")
        return table
    }()
    
    
    //MARK: - Setup
    private func setupFavUI() {
        setFavTableViewContraints()
        setupNavBar()
        setDelegates()
    }
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left.square"), style: .done, target: self, action: #selector(signOutButtonPressed))
    }
    private func setDelegates() {
        favTableView.delegate = self
        favTableView.dataSource = self
    }
    
    //MARK: - Constraints
    private func setFavTableViewContraints() {
        view.addSubview(favTableView)
        favTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            favTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            favTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            favTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    //MARK: - Functions
    private func getUserApiType() {
        DispatchQueue.global(qos: .default).async {
            guard let currentUser = FirebaseAuthService.manager.currentUser else {
                return
            }
            FirestoreService.manager.getUserApiType(from: currentUser.uid) { (result) in
                switch result {
                case .success(let currentApiType):
                    self.apiType = currentApiType
                case .failure(let error):
                    self.makeAlert(with: "Error could not load list", and: "\(error)")
                }
            }
        }
    }
    private func reloadFavs() {
        DispatchQueue.main.async {
            if self.apiType == Experience.ticketmaster.rawValue {
                self.loadFavTickets()
            } else if self.apiType == Experience.rijksmuseum.rawValue {
                self.loadFavArtworks()
            }
        }
    }
    private func makeAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    //MARK: Objc
    @objc func signOutButtonPressed() {
        do {
            try FirebaseAuthService.manager.signOut()
        } catch {
            makeAlert(with: "Problem signing out", and: "\(error)")
        }
    }
    //MARK: Tickets
    private func loadFavTickets() {
        FirestoreService.manager.getFavTicketsFor(userId: FirebaseAuthService.manager.currentUser?.uid ?? "") { (result) in
            switch result {
            case .failure(let error):
                self.makeAlert(with: "Problem loading favorites", and: "\(error)")
            case .success(let favTickets):
                self.favoriteTickets = favTickets
            }
        }
    }
    private func updateTicketHearts(id: String, cell: ListCell) {
        FirestoreService.manager.getFavTickets { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let favedTickets):
                if favedTickets.contains(where: { (ticket) -> Bool in
                    ticket.id == id
                }) {
                    cell.makeHeartFill()
                } else {
                    cell.makeHeartEmpty()
                }
            }
        }
    }
    private func updateCellWithTicketEvents(_ indexPath: IndexPath, _ cell: ListCell) {
        let event = favoriteTickets[indexPath.row]
        cell.mainDescriptionLabel.text = event.name
        cell.additionalInfo.text = event.startDate
        cell.heartButton.tag = indexPath.row
        cell.delegate = self
        
        updateTicketHearts(id: event.id, cell: cell)
        
        DispatchQueue.main.async {
            ImageHelper.shared.fetchImage(urlString: event.imageUrl ?? "") { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let image):
                    cell.listImage.image = image
                }
            }
        }
    }
    //MARK: Museum
    private func loadFavArtworks() {
        FirestoreService.manager.getFavArtsFor(userId: FirebaseAuthService.manager.currentUser?.uid ?? "") { (result) in
            switch result {
            case .failure(let error):
                self.makeAlert(with: "Problem loading favorites", and: "\(error)")
            case .success(let favArts):
                self.favoriteArtObjects = favArts
            }
        }
    }
    private func updateCellWithMuseumArt(_ indexPath: IndexPath, _ cell: ListCell) {
        let art = favoriteArtObjects[indexPath.row]
        cell.mainDescriptionLabel.text = art.title
        cell.additionalInfo.text = art.principleMaker
        cell.heartButton.tag = indexPath.row
        cell.delegate = self
        
        updateArtHearts(id: art.id, cell: cell)
        
        DispatchQueue.main.async {
            ImageHelper.shared.fetchImage(urlString: art.imageUrl ?? "") { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                    cell.listImage.image = UIImage(named: "noImage")
                case .success(let artImage):
                    cell.listImage.image = artImage
                }
            }
        }
    }
    private func updateArtHearts(id: String, cell: ListCell) {
        FirestoreService.manager.getFavArtworks { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let favedArts):
                if favedArts.contains(where: { (art) -> Bool in
                    art.id == id
                }) {
                    cell.makeHeartFill()
                } else {
                    cell.makeHeartEmpty()
                }
            }
        }
    }
    //MARK: Firestore
    private func saveFavTicketToFirestore(_ tag: Int) {
        let favedEvent = favoriteTickets[tag]
        let newFireStoreTicket = FavoriteTickets(createdBy: FirebaseAuthService.manager.currentUser?.uid ?? "", startDate: favedEvent.startDate ?? "", imageUrl: favedEvent.imageUrl ?? "", ticketId: favedEvent.id ,name: favedEvent.name ?? "")
        FirestoreService.manager.createFaveTicket(favedTicket: newFireStoreTicket) { (result) in
            switch result {
            case .success:
                print("Successfully saved in firestore")
            case .failure(let error):
                print(error)
            }
        }
    }
    private func saveFavArtToFirestore(_ tag: Int) {
        let favedArt = favoriteArtObjects[tag]
        let newFirestoreArt = FavoriteMuseumArtworks(createdBy: FirebaseAuthService.manager.currentUser?.uid ?? "", principleMaker: favedArt.principleMaker ?? "", imageUrl: favedArt.imageUrl ?? "", objectId: favedArt.id ,title: favedArt.title ?? "")
        FirestoreService.manager.createFaveArtwork(favedArt: newFirestoreArt) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                print("Art successfully saved in firestore")
            }
        }
    }
    private func deleteTicketFromFirestore(_ tag: Int) {
        let unFavedEvent = favoriteTickets[tag]
        FirestoreService.manager.findIdOfUnfavored(ticket: unFavedEvent.id, userId: FirebaseAuthService.manager.currentUser?.uid ?? "") { (result) in
            FirestoreService.manager.unfavoritedTicket(result: result) { (unFavresult) in
                switch unFavresult {
                case .failure(let error):
                    print("Problem deleting Ticket from FireStore: \(error)")
                case .success:
                    print("Ticket successfully unfavorited")
                }
            }
        }
    }
    private func deleteArtFromFirestore(_ tag: Int) {
        let unFavedArt = favoriteArtObjects[tag]
        FirestoreService.manager.findIdForUnFaved(art: unFavedArt.objectId ?? "", userId: FirebaseAuthService.manager.currentUser?.uid ?? "") { (result) in
            FirestoreService.manager.unfavoritedArt(result: result) { (result) in
                switch result {
                case .failure(let error):
                    print("Problem deleting Art from FireStore: \(error)")
                case .success:
                    print("Art successfully unfavorited")
                }
            }
        }
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupFavUI()
        getUserApiType()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFavs()
    }
    
    
}

//MARK: Extensions - TableView
extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apiType == Experience.ticketmaster.rawValue {
            return favoriteTickets.count
        } else if apiType == Experience.rijksmuseum.rawValue {
            return favoriteArtObjects.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        if apiType == Experience.ticketmaster.rawValue {
            updateCellWithTicketEvents(indexPath, cell)
        } else if apiType == Experience.rijksmuseum.rawValue {
            updateCellWithMuseumArt(indexPath, cell)
        }
        return cell
    }
    
    
}

//MARK: Extension
extension FavoritesVC: HeartButtonDelegate {
    func saveToPersistance(tag: Int) {
        if apiType == "Ticketmaster" {
            saveFavTicketToFirestore(tag)
        } else if apiType == "Rijksmuseum" {
            saveFavArtToFirestore(tag)
        }
    }
    
    func deleteFromPersistance(tag: Int) {
        if apiType == "Ticketmaster" {
            deleteTicketFromFirestore(tag)
        } else if apiType == "Rijksmuseum" {
            deleteArtFromFirestore(tag)
        }
    }
    
    
}
