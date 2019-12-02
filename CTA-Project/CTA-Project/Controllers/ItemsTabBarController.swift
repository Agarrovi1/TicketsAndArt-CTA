//
//  ItemsTabBarController.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class ItemsTabBarController: UITabBarController {
    var listItemVC = UINavigationController.init(rootViewController: ListItemsVC())

    override func viewDidLoad() {
        super.viewDidLoad()
        listItemVC.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "line.horizontal.3"), tag: 0)

        viewControllers = [listItemVC]
        
    }
    

}