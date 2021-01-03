//
//  MainTabControllerViewController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 28.12.2020.
//

import UIKit

class MainTabControllerViewController: UITabBarController {

    //MARK: Properties
    
    
    //MARK: Lifestyle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureViewControllers()
        
        
    }
    
    //MARK: Helpers
    func configureViewControllers() {
      
        let friends = FriendsController()
        let navFriends = templateNavController(image: UIImage(systemName: "person.2"), rootViewController: friends)
        
        let groups = GroupsController()
        let navGroups = templateNavController(image: UIImage(systemName: "person.3.fill"), rootViewController: groups)
      
        let news = NewsController()
        let navNews = templateNavController(image: UIImage(systemName: "newspaper"), rootViewController: news)

        viewControllers = [navFriends, navGroups, navNews]
    }
    
    func templateNavController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = TransitionNavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        return nav
    }

}
