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
    private func makeAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
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
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}

//MARK: SearchBar
extension ListItemsVC: UISearchBarDelegate {
    
}
