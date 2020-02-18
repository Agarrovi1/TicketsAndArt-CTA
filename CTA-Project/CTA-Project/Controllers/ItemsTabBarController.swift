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
    var favVC = UINavigationController.init(rootViewController: FavoritesVC())
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        listItemVC.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "line.horizontal.3"), tag: 0)
        favVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        guard let settingVC = storyBoard.instantiateViewController(withIdentifier: "settingVC") as? SettingVC else {return}
        settingVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        viewControllers = [listItemVC,favVC,settingVC]
        
    }
    

}
