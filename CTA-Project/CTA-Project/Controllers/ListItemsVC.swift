//
//  ListItemsVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class ListItemsVC: UIViewController {
    //MARK: - Properties
    var apiType = "" {
        didSet {
            print(apiType)
        }
    }
    var searchQuery: String? {
        didSet {
            guard let searchQuery = searchQuery, !searchQuery.isEmpty else {
                return
            }
            DispatchQueue.main.async {
                if self.apiType == "Ticketmaster" {
                self.loadEvents(query: searchQuery.lowercased())
                } else if self.apiType == "Rijksmuseum" {
                    self.loadArtworks(query: searchQuery)
                }
            }
        }
    }
    var events = [Event]() {
        didSet {
            listTableView.reloadData()
        }
    }
    var artworks = [ArtObject]() {
        didSet {
            listTableView.reloadData()
        }
    }
    
    //MARK: - Objects
    var listTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.register(ListCell.self, forCellReuseIdentifier: "listCell")
        return table
    }()
    var listSearchBar: UISearchBar = {
        let bar = UISearchBar()
        return bar
    }()
    
    //MARK: - Setup
    private func setupListUI() {
        setupNavBar()
        setListSearchBarConstraints()
        setTableViewContraints()
        setDelegates()
    }
    private func setupNavBar() {
        navigationItem.title = "List of Things"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left.square"), style: .done, target: nil, action: nil)
    }
    private func setDelegates() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listSearchBar.delegate = self
    }
    
    //MARK: - Contraints
    private func setListSearchBarConstraints() {
        view.addSubview(listSearchBar)
        listSearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)])
    }
    private func setTableViewContraints() {
        view.addSubview(listTableView)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: listSearchBar.bottomAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    //MARK: - Functions
    private func makeAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
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
    //MARK: TicketMaster
    private func loadEvents(query: String) {
        TicketAPIHelper.manager.getEvents(query: query) { (result) in
            switch result {
            case .failure(let error):
                //self.makeAlert(with: "Error", and: "\(error)")
                print(error)
            case .success(let eventsFromJson):
                self.events = eventsFromJson
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
        let event = events[indexPath.row]
        cell.mainDescriptionLabel.text = event.name
        cell.additionalInfo.text = event.getFormattedDate()
        cell.heartButton.tag = indexPath.row
        cell.delegate = self
        
        updateTicketHearts(id: event.id, cell: cell)
        
        DispatchQueue.main.async {
            ImageHelper.shared.fetchImage(urlString: event.images[0].url) { (result) in
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
    private func loadArtworks(query: String) {
        MuseumAPIHelper.manager.getArtObjects(query: query) { (result) in
            switch result {
            case .failure(let error):
                self.makeAlert(with: "Unable to find results for this query", and: "Try something else")
            case .success(let arts):
                self.artworks = arts
            }
        }
    }
    private func updateCellWithMuseumArt(_ indexPath: IndexPath, _ cell: ListCell) {
        let art = artworks[indexPath.row]
        cell.mainDescriptionLabel.text = art.title
        cell.additionalInfo.text = art.principalOrFirstMaker
        cell.heartButton.tag = indexPath.row
        cell.delegate = self
        
        updateArtHearts(id: art.objectNumber, cell: cell)
        
        DispatchQueue.main.async {
            if art.hasImage {
                if let webImageUrl = art.webImage?.url {
                    ImageHelper.shared.fetchImage(urlString: webImageUrl) { (result) in
                        switch result {
                        case .failure(let error):
                            print(error)
                            cell.listImage.image = UIImage(named: "noImage")
                        case .success(let artImage):
                            cell.listImage.image = artImage
                        }
                    }
                } else {
                    cell.listImage.image = UIImage(named: "noImage")
                }
            } else {
                cell.listImage.image = UIImage(named: "noImage")
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
        let favedEvent = events[tag]
        let newFireStoreTicket = FavoriteTickets(createdBy: FirebaseAuthService.manager.currentUser?.uid ?? "", startDate: favedEvent.getFormattedDate(), imageUrl: favedEvent.images[0].url, ticketId: favedEvent.id,name: favedEvent.name)
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
        let favedArt = artworks[tag]
        let newFirestoreArt = FavoriteMuseumArtworks(createdBy: FirebaseAuthService.manager.currentUser?.uid ?? "", principleMaker: favedArt.principalOrFirstMaker, imageUrl: favedArt.webImage?.url ?? "", objectId: favedArt.objectNumber,title: favedArt.title)
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
        let unFavedEvent = events[tag]
        FirestoreService.manager.unfavoritedTicket(ticketId: unFavedEvent.id) { (result) in
            switch result {
            case .failure(let error):
                print("Problem deleting Ticket from FireStore: \(error)")
            case .success:
                print("Ticket successfully unfavorited")
            }
        }
    }
    private func deleteArtFromFirestore(_ tag: Int) {
        let unFavedArt = artworks[tag]
        FirestoreService.manager.unfavoritedArt(objectId: unFavedArt.objectNumber) { (result) in
            switch result {
            case .failure(let error):
                print("Problem deleting Art from FireStore: \(error)")
            case .success:
                print("Art successfully unfavorited")
            }
        }
    }
    
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupListUI()
        getUserApiType()

    }

}

//MARK: - Extensions: TableView
extension ListItemsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if apiType == "Ticketmaster" {
            return events.count
        } else if apiType == "Rijksmuseum" {
            return artworks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        cell.listImage.image = nil
        if apiType == "Ticketmaster" {
            updateCellWithTicketEvents(indexPath, cell)
        } else if apiType == "Rijksmuseum" {
            updateCellWithMuseumArt(indexPath, cell)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        if apiType == "Ticketmaster" {
            detailVC.ticketEvent = events[indexPath.row]
        } else if apiType == "Rijksmuseum" {
            detailVC.art = artworks[indexPath.row]
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? ListCell else {return}
        switch cell.heartStatus {
        case .filled:
            detailVC.heartStatus = .filled
        case .notFilled:
            detailVC.heartStatus = .notFilled
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}

//MARK: SearchBar
extension ListItemsVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = searchBar.text
        searchBar.resignFirstResponder()
    }
}

//MARK: HeartButton
extension ListItemsVC: HeartButtonDelegate {
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
