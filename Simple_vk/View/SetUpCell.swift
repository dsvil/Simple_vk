//
// Created by Sergei Dorozhkin on 30.12.2020.
//

import UIKit

class SetUpCell: UITableViewCell {

    //MARK: Properties
    var friend: VkFriend? {
        didSet {
            configureFriendList()
        }
    }
    var group: VkGroup? {
        didSet {
            configureGroupList()
        }
    }

    private let profileImageView: AnimViewImage = {
        let view = AnimViewImage()
        view.sizeSetUP(side: 60)
        return view
    }()

    private let shadowView: AnimView = {
        let view = AnimView()
        view.sizeSetUP(side: 60)
        return view
    }()

    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Dorozhkin Sergei"
        return label
    }()

    //MARK: Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(shadowView)
        addSubview(infoLabel)
        setGradientForCells()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(shadowView)
        shadowView.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor,
                paddingTop: 8, paddingBottom: 8, paddingRight: 8)

        shadowView.addSubview(profileImageView)
        profileImageView.addConstraintsToFillView(shadowView)

        addSubview(infoLabel)
        infoLabel.centerY(inView: self)
        infoLabel.anchor(left: leftAnchor, right: shadowView.leftAnchor, paddingLeft: 8, paddingRight: 8)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: Helpers

    func configureFriendList() {
        guard let friend = friend else {
            return
        }
        let viewModel = FriendsViewModel(friend: friend)
        infoLabel.attributedText = viewModel.item
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }

    func configureGroupList() {
        guard let group = group else {
            return
        }
        let viewModel = GroupViewModel(group: group)
        infoLabel.attributedText = viewModel.item
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}

