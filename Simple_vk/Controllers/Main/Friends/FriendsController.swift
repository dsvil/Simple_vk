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
    private var friends = [VkFriend]()
    let searchController = UISearchController(searchResultsController: nil)

    private var undeletedFriends = [VkFriend]()
    private var charactersBeforeSearch = [Character]()
    private var sortedFriendsBeforeSearch: [Character: [VkFriend]] = [:]

    private var filteredFirstCharacters = [Character]()
    private var filteredSortedFriends: [Character: [VkFriend]] = [:]

    // MARK: Lifestyle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
        ApiGetFriendsVK.shared.getData { [weak self] in
            self?.loadData()
        }
    }

    func loadData() {
        do {
            let realm = try Realm()
            let realmFriends = realm.objects(VkFriend.self)
            friends = Array(realmFriends)
            (filteredFirstCharacters, filteredSortedFriends) = sort(friends)
            (charactersBeforeSearch, sortedFriendsBeforeSearch) = sort(friends)
            tableView.reloadData()
        } catch {
            print(error)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SetUpCell
        let character = filteredFirstCharacters[indexPath.section]
        let char = filteredSortedFriends[character]
        cell.friend = char![indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let character = filteredFirstCharacters[indexPath.section]
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            filteredSortedFriends[character]!.remove(at: indexPath.row)
            sortedFriendsBeforeSearch = filteredSortedFriends

            let sectionsToDelete = filteredSortedFriends[character]
            if sectionsToDelete?.count == 0 {
                filteredSortedFriends[character] = nil
                sortedFriendsBeforeSearch = filteredSortedFriends
                guard let charToDelete = filteredFirstCharacters.firstIndex(of: character) else {
                    return
                }
                filteredFirstCharacters.remove(at: charToDelete)
                charactersBeforeSearch = filteredFirstCharacters

                for character in filteredFirstCharacters {
                    for element in filteredSortedFriends[character]! {
                        undeletedFriends.append(element)
                    }
                }
                tableView.deleteSections(indexSet, with: .left)
            } else {
                for character in filteredFirstCharacters {
                    for element in filteredSortedFriends[character]! {
                        undeletedFriends.append(element)
                    }
                }
                tableView.deleteRows(at: [indexPath], with: .middle)
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
        var text = searchController.searchBar.text
        guard let textInSearch = text else { return }
        if textInSearch.isEmpty {
            text = ""
            filteredFirstCharacters = charactersBeforeSearch
            filteredSortedFriends = sortedFriendsBeforeSearch
            view.endEditing(true)
            tableView.reloadData()
        } else {
            var filteredFriends = [VkFriend]()
            if undeletedFriends.isEmpty {
                filteredFriends = friends.filter { friend in
                    friend.firstName.lowercased().contains(textInSearch.lowercased()) || friend.lastName.lowercased().contains(textInSearch.lowercased())
                }
            } else {
                filteredFriends = undeletedFriends.filter { friend in
                    friend.firstName.lowercased().contains(textInSearch.lowercased()) || friend.lastName.lowercased().contains(textInSearch.lowercased())
                }
            }
            (filteredFirstCharacters, filteredSortedFriends) = sort(filteredFriends)
            tableView.reloadData()
        }
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

    func sort(_ friends: [VkFriend]) -> (characters: [Character], sortedFriends: [Character: [VkFriend]]) {
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
