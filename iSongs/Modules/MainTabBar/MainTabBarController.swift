//
//  MainTabBarController.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tabBar.tintColor = #colorLiteral(red: 0.937254902, green: 0.1960784314, blue: 0.3725490196, alpha: 1)
        tabBar.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 0.94)
        
        let searchVC: SearchViewController = SearchViewController()
        let histoyVC: HistoryViewController = HistoryViewController()
        
        viewControllers = [ generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "SearchIcon"), title: "Search"), generateViewController(rootViewController: histoyVC, image: #imageLiteral(resourceName: "HistoryIcon"), title: "History") ]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        return navigationVC
    }
    
}
