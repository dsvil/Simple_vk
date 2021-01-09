//
//  GroupsController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 28.12.2020.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "GroupsCell"

class GroupsController: UITableViewController  {

    // MARK: Properties
    private var fullGroups = [VkGroup]()
    private var groups = [VkGroup]()

//    let searchController = UISearchController(searchResultsController: nil)
//        UISearchResultsUpdating

    // MARK: Lifestyle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        configureUI()
        ApiGetGroupsVK.shared.getData { [weak self] in
            self?.loadData()
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SetUpCell
        cell.group = groups[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            fullGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let newGroup = groups[indexPath.row]
//        if tableView.tableHeaderView == searchController.searchBar {
//            if !fullGroups.contains(where: { fullGroups -> Bool in
//                newGroup.name == fullGroups.name
//            }) {
//                fullGroups.append(newGroup)
//                groups = fullGroups
//                tableView.tableHeaderView = nil
//                tableView.reloadData()
//            }
//            groups = fullGroups
//            tableView.tableHeaderView = nil
//            tableView.reloadData()
//        } else {
//            print("Action Code here!!!")
//        }
        print("DEBUG: Action Code here!!!")
    }

    //MARK: Search

//    func updateSearchResults(for searchController: UISearchController) {
//        var text = searchController.searchBar.text
//        if text!.isEmpty {
//            text = ""
//        } else {
//            ApiGetGroupsVKSearch.shared.getData(searchText: text!) { [self]groups in
//                self.groups = groups
//                tableView.reloadData()
//            }
//        }
//    }

    //MARK: Helpers

    func configureUI() {
        tableView.register(SetUpCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .black
        navigationItem.title = "Groups"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                target: self, action: #selector(openSearchGroups))
    }
    func loadData() {
        do {
            let realm = try Realm()
            let realmGroups = realm.objects(VkGroup.self).sorted(byKeyPath: "name")
            groups = Array(realmGroups)
            fullGroups = groups
            tableView.reloadData()
        } catch {
            print(error)
        }
    }


    //MARK: Selectors
    @objc func openSearchGroups() {
//        searchController.searchResultsUpdater = self
//        searchController.automaticallyShowsCancelButton = false
//        searchController.hidesNavigationBarDuringPresentation = false
//        tableView.tableHeaderView = searchController.searchBar
    print("DEBUG: Going to search")
    }
}



