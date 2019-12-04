//
//  FavoritesVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController {
    
    
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
        navigationItem.title = "Favorite Things"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left.square"), style: .done, target: nil, action: nil)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupFavUI()
    }
    


}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    
}
