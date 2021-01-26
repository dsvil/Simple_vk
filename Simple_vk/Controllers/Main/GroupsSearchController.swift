//
// Created by Sergei Dorozhkin on 09.01.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "GroupsCell"

class GroupsSearchController: UITableViewController, UISearchResultsUpdating {

    // MARK: - Properties
    private var groups = [VkGroup]() {
        didSet {
            tableView.reloadData()
        }
    }
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - Lifescycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchController()
    }

    // MARK: - Helpers
    func configureUI() {
        tableView.register(SetUpCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .black
        navigationItem.title = "Groups Search"

    }

    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchResultsUpdater = self
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
        let text = searchController.searchBar.text
        if text!.isEmpty {
            groups = []
        } else {
            ApiGetGroupsVKSearch.shared.getData(searchText: text!) { [self]groups in
                self.groups = groups
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
        let groupAtIndex = groups[indexPath.row]
        uploadSelectedGroup(groupAtIndex)
        let group = GroupsToWrite(id: groupAtIndex.id, name: groupAtIndex.name, profileImage: groupAtIndex.icon)
        FireService.shared.uploadGroup(group: group) { [weak self](err, ref) in
            if let error = err {
                let alert = Utilities().alert(error.localizedDescription)
                self?.present(alert, animated: true, completion: nil)
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
