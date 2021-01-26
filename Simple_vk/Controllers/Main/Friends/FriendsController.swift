//
//  FriendsController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 28.12.2020.
//

import UIKit
import SDWebImage
import RealmSwift

private let reuseIdentifier = "FriendsCell"

    class FriendsController: UITableViewController, UISearchResultsUpdating {
    // MARK: Properties
    private var friends: Results<VkFriend>?
    private var token: NotificationToken?
    let searchController = UISearchController(searchResultsController: nil)

    private var filteredFirstCharacters = [Character]()
    private var filteredSortedFriends: [Character: [VkFriend]] = [:]

    // MARK: Lifestyle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureUI()
        configureSearchController()
        ApiGetFriendsVK.shared.getData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        filteredFirstCharacters.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let character = filteredFirstCharacters[section]
        let view: UIView = {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
            view.backgroundColor = UIColor.red
            return view
        }()
        let label: UILabel = {
            let label = UILabel(frame: CGRect(x: 15, y: -10, width: tableView.bounds.width - 30, height: 49))
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = UIColor.white
            label.text = String(character)
            return label
        }()
        view.addSubview(label)
        return view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let character = filteredFirstCharacters[section]
        let friendsCount = filteredSortedFriends[character]?.count
        return friendsCount ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FriendsCell
        let character = filteredFirstCharacters[indexPath.section]
        let char = filteredSortedFriends[character]
        cell.friend = char![indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        let character = filteredFirstCharacters[indexPath.section]
        let char = filteredSortedFriends[character]
        let friend = char![indexPath.row]
        
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                let friendPhotos = realm.objects(PhotoStaff.self).filter("friendId == %@", friend.id)
                realm.beginWrite()
                friendPhotos.forEach { photo in
                    realm.delete(photo.sizes)
                }
                realm.delete(friend)
                realm.delete(friendPhotos)

                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photos = FriendPhotoController(collectionViewLayout: UICollectionViewFlowLayout())
        let character = filteredFirstCharacters[indexPath.section]
        if let char = filteredSortedFriends[character] {
            photos.friendsId = char[indexPath.row].id
            photos.title = char[indexPath.row].firstName
        }
        navigationController?.pushViewController(photos, animated: true)
    }

    //MARK: Search

    func updateSearchResults(for searchController: UISearchController) {
        guard let textInSearch = searchController.searchBar.text else {
            return
        }
        if textInSearch.isEmpty {
            (filteredFirstCharacters, filteredSortedFriends) = sort(friends!)
            view.endEditing(true)
            tableView.reloadData()
        } else {
            do {
                let realm = try Realm()
                let predicate = NSPredicate(format: """
                                                    lastName CONTAINS[cd] %@ OR
                                                    firstName CONTAINS[cd] %@
                                                    """, textInSearch, textInSearch)
                let filteredFriends = realm.objects(VkFriend.self).filter(predicate)
                (filteredFirstCharacters, filteredSortedFriends) = sort(filteredFriends)
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }

// MARK: Helpers

    func configureUI() {
        tableView.register(FriendsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .black
        navigationItem.title = "Friends"
    }

    func configureSearchController() {
        searchController.automaticallyShowsCancelButton = true
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        definesPresentationContext = false
        searchController.searchResultsUpdater = self
    }

    func loadData() {
        do {
            let realm = try Realm()
            friends = realm.objects(VkFriend.self)
            (filteredFirstCharacters, filteredSortedFriends) = sort(friends!)
            token = friends!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else {
                    return
                }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, _, _, _):
                    (self!.filteredFirstCharacters, self!.filteredSortedFriends) = self!.sort(self!.friends!)
                    tableView.reloadData()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        } catch {
            print(error)
        }
    }

    func sort(_ friends: Results<VkFriend>) -> (characters: [Character], sortedFriends: [Character: [VkFriend]]) {
        var characters = [Character]()
        var sortedFriends = [Character: [VkFriend]]()
        friends.forEach { friend in
            guard let character = friend.lastName.first else {
                return
            }
            if var thisCharFriends = sortedFriends[character] {
                thisCharFriends.append(friend)
                sortedFriends[character] = thisCharFriends
            } else {
                sortedFriends[character] = [friend]
                characters.append(character)
            }
        }
        characters.sort()
        return (characters, sortedFriends)
    }
}
