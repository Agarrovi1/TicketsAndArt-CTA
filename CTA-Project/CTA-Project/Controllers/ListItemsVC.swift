//
//  ListItemsVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class ListItemsVC: UIViewController {
    
    //MARK: - Objects
    var listTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.register(ListCell.self, forCellReuseIdentifier: "listCell")
        return table
    }()
    
    //MARK: - Setup
    private func setupListUI() {
        setupNavBar()
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
    }
    
    //MARK: - Contraints
    private func setTableViewContraints() {
        view.addSubview(listTableView)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupListUI()

    }

}

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
    
    
}

