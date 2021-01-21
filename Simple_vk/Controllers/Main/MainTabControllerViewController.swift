//
//  MainTabControllerViewController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 28.12.2020.
//

import UIKit
import RealmSwift
import Firebase

class MainTabControllerViewController: UITabBarController {

    //MARK: - Properties
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .red
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    //MARK: - Lifecycle


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewControllers()
//        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }

    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .black
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                paddingBottom: 64, paddingRight: 16, width: 40, height: 40)
        actionButton.layer.cornerRadius = 40 / 2
    }
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out\(error.localizedDescription)")
        }
    }
    
    func logOutFromVKIfNeeded() {
        let controller = VKAuthController()
        controller.revoke = 1
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true, completion: nil)
    }


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
    //MARK: - Selectors
    @objc func actionButtonTapped() {
        logUserOut()
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }

}
