//
//  FriendPhotoController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 01.01.2021.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "PhotoCell"

class FriendPhotoController: UICollectionViewController {

    //MARK: Properties
    var friendsId = Int()
    private var token: NotificationToken?
    private var photos: Results<PhotoStaff>?


    //MARK: Lifestyle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(user: friendsId)

        ApiGetPhotosVK.shared.getData(user: friendsId)
        configureUI()
    }

    func loadData(user: Int) {
        do {
            let realm = try Realm()
            photos = realm.objects(PhotoStaff.self).filter("friendId == %@", user)
            token = photos!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let collectionView = self?.collectionView else { return }
                switch changes {
                case .initial:
                    collectionView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    collectionView.performBatchUpdates({
                        collectionView.insertItems(at: insertions.map({IndexPath(row: $0, section: 0) }))
                        collectionView.deleteItems(at: deletions.map({IndexPath(row: $0, section: 0)}))
                        collectionView.reloadItems(at: modifications.map({IndexPath(row: $0, section: 0) }))
                    }, completion: nil)
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        } catch {
            print(error)
        }
    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionCell
        cell.photo = photos![indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FullScreenImageController()
        controller.startFromImage = indexPath.row
        controller.friendImages = Array(photos!)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    // MARK: Helpers

    func configureUI() {
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }
}

extension FriendPhotoController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width * 0.8
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

