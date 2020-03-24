//
//  MainTabBarController.swift
//  Sleepy-time
//
//  Created by Michael Sidoruk on 05.02.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = #colorLiteral(red: 0.2570016384, green: 0.382270813, blue: 0.5108541846, alpha: 1)
        
        // Do any additional setup after loading the view.
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
//        let tryWeatherViewController = TryWeatherViewController()
//        tryWeatherViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        
//        let sb = UIStoryboard(name: "Settings", bundle: nil)
//        let settingsViewController = sb.instantiateViewController(withIdentifier: "NewSettingsViewController") as! NewSettingsViewController
//        settingsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 2)
        
        viewControllers = [navigationController]

        
    }
    
}
