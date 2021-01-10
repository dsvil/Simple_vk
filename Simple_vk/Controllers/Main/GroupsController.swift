//
//  GroupsController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 28.12.2020.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "GroupsCell"

class GroupsController: UITableViewController {

    // MARK: - Properties
    private var token: NotificationToken?
    private var groups: Results<VkGroup>?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureUI()
        ApiGetGroupsVK.shared.getData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SetUpCell
        cell.group = groups![indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let group = groups![indexPath.row]
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(group)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Action Code here!!!")
    }

//MARK: - Helpers

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
            groups = realm.objects(VkGroup.self).sorted(byKeyPath: "name")
            token = groups!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else {
                    return
                }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.endUpdates()
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        } catch {
            print(error)
        }
    }

//MARK: - Selectors
    @objc func openSearchGroups() {
        let controller = GroupsSearchController()
        navigationController?.pushViewController(controller, animated: true)
    }
}



