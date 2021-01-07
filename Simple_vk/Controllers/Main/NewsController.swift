//
//  NewsController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 29.12.2020.
//

import UIKit

private let reuseIdentifier = "NewsCell"

class NewsController: UITableViewController {

    //MARK: Properties


    //MARK: Lifestyle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.register(NewsCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .black
        ApiGetNewsVK.shared.getData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
                withIdentifier: reuseIdentifier,
                for: indexPath) as! NewsCell

        return cell
    }


}


////MARK: Collection View Setup
//
//extension NewsController {
//    override func collectionView(_ collectionView: UICollectionView,
//                                 numberOfItemsInSection section: Int) -> Int {
//        super.collectionView(collectionView, numberOfItemsInSection: section)
//        return 5
//    }
//
//    override func collectionView(_ collectionView: UICollectionView,
//                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        super.collectionView(collectionView, cellForItemAt: indexPath)
//        let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: reuseIdentifier,
//                for: indexPath) as! NewsCell
//        
//        
//        return cell
//    }
//}
//
//extension NewsController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView,
//                               layout collectionViewLayout: UICollectionViewLayout,
//                               sizeForItemAt indexPath: IndexPath) -> CGSize {
//return CGSize(width: view.frame.width, height: 360)
//    }
//}

