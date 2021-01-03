//
//  FriendPhotoController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 01.01.2021.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class FriendPhotoController: UICollectionViewController {

    //MARK: Properties
    var friendsId = Int()
    var photos = [PhotoStaff]() {
        didSet {
            collectionView.reloadData()
        }
    }

    //MARK: Lifestyle

    override func viewDidLoad() {
        super.viewDidLoad()
        ApiGetPhotosVK.shared.getData(user: friendsId) { [self](photos) in
            self.photos = photos
        }
        configureUI()
    }


    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionCell

        cell.photo = photos[indexPath.row]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let controller = FullScreenImageController()
            controller.startFromImage = indexPath.row
            controller.friendImages = self.photos
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }
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

