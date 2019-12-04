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
                }
            }
        }
    }
    var events = [Event]() {
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
    private func makeAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        detailVC.ticketEvent = events[indexPath.row]
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
        let favedEvent = events[tag]
        let newFireStoreTicket = FavoriteTickets(createdBy: FirebaseAuthService.manager.currentUser?.uid ?? "", startDate: favedEvent.getFormattedDate(), imageUrl: favedEvent.images[0].url, ticketId: favedEvent.id)
        FirestoreService.manager.createFaveTicket(favedTicket: newFireStoreTicket) { (result) in
            switch result {
            case .success:
                print("Successfully saved in firestore")
            case .failure(let error):
                print(error)
            }
        }

    }
    
    func deleteFromPersistance(tag: Int) {
        let unFavedEvent = events[tag]
        FirestoreService.manager.unfavoritedTicket(ticketId: unFavedEvent.id) { (result) in
            switch result {
            case .failure(let error):
                print("Problem deleting from FireStore: \(error)")
            case .success:
                print("successfully unfavorited")
            }
        }
    }
    
    
}
