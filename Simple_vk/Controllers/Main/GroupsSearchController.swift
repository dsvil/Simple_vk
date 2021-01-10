//
// Created by Sergei Dorozhkin on 09.01.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "GroupsCell"

class GroupsSearchController: UITableViewController, UISearchResultsUpdating {

    // MARK: - Properties
    private var groups = [VkGroup]()
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifescycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helpers
    func configureUI() {
        tableView.register(SetUpCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .black
        navigationItem.title = "Groups Search"
        searchController.searchResultsUpdater = self
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
    }

    func uploadSelectedGroup(_ item: VkGroup) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(item, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

    // MARK: - SearchController
    func updateSearchResults(for searchController: UISearchController) {
        var text = searchController.searchBar.text
        if text!.isEmpty {
            text = ""
        } else {
            ApiGetGroupsVKSearch.shared.getData(searchText: text!) { [self]groups in
                self.groups = groups
                tableView.reloadData()
            }
        }
    }


    // MARK: - Table view setup
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SetUpCell
        cell.group = groups[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        uploadSelectedGroup(groups[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}