//
//  PhotoCollectionCell.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 01.01.2021.
//

import UIKit
import RealmSwift

class PhotoCollectionCell: UICollectionViewCell {

    var photo: PhotoStaff? {
        didSet {
            configure()
        }
    }

    private let photoImage: UIImageView = {
        let image = UIImageView()
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(photoImage)
        photoImage.center(inView: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        guard let photo = photo else {
            return
        }
        let count = photo.sizes.count
        switch count {
        case _ where count >= 4:
            applyCount(3)
        case 3:
            applyCount(2)
        default:
            applyCount(0)
        }

    }
    func applyCount (_ size: Int) {
        let url = URL(string: photo!.sizes[size].url)
        photoImage.sd_setImage(with: url)
        
    }
}
