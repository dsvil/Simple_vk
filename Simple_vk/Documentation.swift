//
//  Documentation.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 01.01.2021.
//

/*
 1. Друзья:
 * Переписать друзей в более чистый код
 2. Группы:
 * реальное добавление и удаление групп пользователя
 * отмена поиска групп
 3. *Сделать реализацию действий кнопок новостей (комментарии, перепост, лайки)

 4. Сделать страницу новостей на базе стеков
 - Лейаут страницы с пробными данными (в поезде)
 - Наполнить реальными данными (в поезде)
 - Работа с базами данных, загрузка данных из базы (в поезеде)
 
 */

/*

import UIKit
import SDWebImage

private let reuseIdentifier = "FriendsCell"

class FriendsController: UITableViewController, UISearchResultsUpdating {

    // MARK: Properties
    private var friends = [VkFriend]()
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: Lifestyle


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        ApiGetFriendsVK.shared.getData { [self] friends in
            self.friends = friends
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SetUpCell
        cell.friend = friends[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photos = FriendPhotoController(collectionViewLayout: UICollectionViewFlowLayout())
        photos.friendsId = friends[indexPath.row].id
        navigationController?.pushViewController(photos, animated: true)
    }

    //MARK: Search

    func updateSearchResults(for searchController: UISearchController) {

    }

// MARK: Helpers

    func configureUI() {
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        tableView.register(SetUpCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .black
        navigationItem.title = "Friends"
    }
}
 */